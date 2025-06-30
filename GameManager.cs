using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
	public static GameManager SP;

	public Transform playerPrefab;

	private int blocks;

	private bool finishedLoading;

	private string URL = "http://gamedata.cubelands.com/servers.php";

	private List<PlayerNode> playerList = new List<PlayerNode>();

	public PlayerNode localPlayerNode;

	private float lastRegister = -99999f;

	private bool quitting;

	private int serverID;

	public static bool IsAdmin(PlayerNode pNode)
	{
		return pNode.isAdmin;
	}

	public static bool IsMod(PlayerNode pNode)
	{
		return pNode.isAdmin || pNode.isMod;
	}

	public static bool AllowInput()
	{
		return !Chat.IsUsing() && Screen.lockCursor;
	}

	public static bool AllowPlayerBuild(PlayerNode player)
	{
		return !GameSettings.useBuilderList || player.isBuilder;
	}

	public static bool AllowPlayerBuild(NetworkPlayer nplayer)
	{
		return AllowPlayerBuild(SP.GetPlayer(nplayer));
	}

	private void Awake()
	{
		Network.isMessageQueueRunning = true;
		Application.runInBackground = true;
		SP = this;
		if (!Network.isClient && !Network.isServer)
		{
			if (Application.platform != RuntimePlatform.WindowsEditor)
			{
				Debug.LogError("No connection in-game, should never happen!");
			}
			GameSettings.gameHadError = "You had no connection in-game! This happens when there's already a multiplayer server hosting on the same port.";
			Application.LoadLevel(Application.loadedLevel - 1);
		}
		InvokeRepeating("Ping", 0f, 299f);
	}

	private IEnumerator Start()
	{
		if (!DedicatedServer.isDedicated)
		{
			AddPlayer(Network.player, AccountManager.GetUsername(), AccountManager.BoughtGame(), AccountManager.GetUserID(), AccountManager.GetUserSkinID());
			base.networkView.RPC("AddPlayer", RPCMode.OthersBuffered, Network.player, AccountManager.GetUsername(), AccountManager.BoughtGame(), AccountManager.GetUserID(), AccountManager.GetUserSkinID());
		}
		while (!finishedLoading)
		{
			yield return 0;
		}
		yield return 0;
		if (Network.isServer)
		{
			ServerStarted();
			if (!DedicatedServer.isDedicated)
			{
				SpawnLocalPlayer();
			}
		}
		else
		{
			base.networkView.RPC("SendAuthentication", RPCMode.Server, AccountManager.GetUserID(), AccountManager.GetSessionKey().Substring(0, 15));
			SpawnLocalPlayer();
		}
		Statistics.AddStat(Stats.gamesPlayed, 1);
	}

	private void Ping()
	{
		StartCoroutine(DoPing());
	}

	private IEnumerator DoPing()
	{
		if (!AccountManager.RealAccount() || DedicatedServer.isDedicated)
		{
			yield break;
		}
		IENumeratorOutput output = new IENumeratorOutput();
		yield return StartCoroutine(AccountManager.Ping(output));
		if (output.Failed())
		{
			int resultCode = (int)output.GetOutput();
			if (resultCode == 2)
			{
				Debug.Log("Quit, sessionerror");
				GameSettings.gameHadError = "Your account has logged in from another location.";
				StartCoroutine(QuitGame());
			}
		}
	}

	public void OnConnectedToServer()
	{
		playerList = new List<PlayerNode>();
	}

	[RPC]
	private IEnumerator SendAuthentication(int userID, string sessionpart, NetworkMessageInfo info)
	{
		Debug.Log("SERVER: authenticato" + userID);
		string result2 = string.Empty;
		WWWForm form = new WWWForm();
		form.AddField("action", "checkuser");
		form.AddField("userID", userID);
		form.AddField("sessionpart", sessionpart);
		WWW post = new WWW(URL, form);
		yield return post;
		Debug.Log("authenticate res=" + post.text);
		if (post.error == null)
		{
			result2 = post.text;
			if (userID == 0)
			{
				result2 = "2";
			}
			PlayerNode pNode = GetPlayer(info.sender);
			float started = Time.realtimeSinceStartup;
			while (pNode == null && Time.realtimeSinceStartup < started + 120f)
			{
				yield return new WaitForSeconds(0.5f);
				pNode = GetPlayer(info.sender);
			}
			if (pNode == null)
			{
				Debug.LogError("Couldnt authenticate user because we dont have its playernode!");
				yield break;
			}
			if (result2 == "2")
			{
				StartCoroutine(DisconnectClient(info.sender, "Invalid session, try logging out and in again."));
				yield break;
			}
			ClientHasAuthenticated(pNode);
			pNode.authenticated = true;
		}
	}

	private void ClientHasAuthenticated(PlayerNode pNode)
	{
		Debug.Log("ClientHasAuthenticated");
		if (GameSettings.bannedList.Contains(pNode.name))
		{
			Ban(pNode.networkPlayer);
		}
	}

	public void OnPlayerDisconnected(NetworkPlayer player)
	{
		PlayerNode player2 = GetPlayer(player);
		if (player2 != null)
		{
			string text = GetPlayer(player).name;
			Chat.SP.addGameChatMessage(text + " left the game");
			WorldData.SP.ServerRemovePlayer(player2);
		}
		base.networkView.RPC("RemovePlayer", RPCMode.All, player);
		Network.RemoveRPCs(player);
		Network.DestroyPlayerObjects(player);
	}

	private void ReloadPrivileges()
	{
		foreach (PlayerNode player in playerList)
		{
			player.isAdmin = GameSettings.adminList.Contains(player.name);
			player.isMod = player.isAdmin || GameSettings.modList.Contains(player.name);
			player.isBuilder = GameSettings.builderList.Contains(player.name);
		}
	}

	private IEnumerator OnPlayerConnected(NetworkPlayer player)
	{
		Debug.Log("OnPlayerConnected beg");
		SendGameServerData(player);
		Chat.SP.addGameChatMessage(GameSettings.motd, player);
		yield return new WaitForSeconds(0.2f);
		WorldData.SP.SendLevelData(player);
		Debug.Log("OnPlayerConnected end");
	}

	public void RequestKick(NetworkPlayer player)
	{
		if (Network.isServer)
		{
			DoKick(player);
			return;
		}
		base.networkView.RPC("AskKick", RPCMode.Server, player);
	}

	[RPC]
	private void AskKick(NetworkPlayer player, NetworkMessageInfo info)
	{
		PlayerNode player2 = GetPlayer(info.sender);
		if (IsMod(player2))
		{
			DoKick(player);
		}
	}

	public void DoKick(NetworkPlayer player)
	{
		PlayerNode player2 = GetPlayer(player);
		if (player2 != null && !player2.isAdmin)
		{
			StartCoroutine(DisconnectClient(player, "Kicked from the server."));
		}
	}

	public IEnumerator DisconnectClient(NetworkPlayer pla, string reason)
	{
		base.networkView.RPC("ClientDisconnection", pla, reason);
		yield return new WaitForSeconds(0.1f);
		Network.CloseConnection(pla, sendDisconnectionNotification: true);
	}

	[RPC]
	public void ClientDisconnection(string reason)
	{
		GameSettings.gameHadError = "Disconnected from server, reason: " + reason;
	}

	public void Ban(NetworkPlayer player)
	{
		if (Network.isServer)
		{
			PlayerNode player2 = GetPlayer(player);
			if (player2 != null && !player2.isAdmin)
			{
				if (!GameSettings.bannedList.Contains(player2.name))
				{
					GameSettings.bannedList.Add(player2.name);
				}
				StartCoroutine(DisconnectClient(player, "Banned from the server"));
			}
		}
		else
		{
			base.networkView.RPC("Ban", RPCMode.Server, player);
		}
	}

	[RPC]
	private void Ban(NetworkPlayer player, NetworkMessageInfo info)
	{
		PlayerNode player2 = GetPlayer(info.sender);
		if (IsMod(player2))
		{
			Ban(player);
		}
	}

	public void Unban(string playerName)
	{
		if (Network.isServer)
		{
			if (GameSettings.bannedList.Contains(playerName))
			{
				GameSettings.bannedList.Remove(playerName);
			}
		}
		else
		{
			base.networkView.RPC("Unban", RPCMode.Server, playerName);
		}
	}

	[RPC]
	private void Unban(string playerName, NetworkMessageInfo info)
	{
		PlayerNode player = GetPlayer(info.sender);
		if (IsMod(player))
		{
			Unban(playerName);
		}
	}

	private void SendGameServerData(NetworkPlayer player)
	{
		if (Network.isServer || (localPlayerNode != null && localPlayerNode.isAdmin))
		{
			base.networkView.RPC("ReceiveServerData", player, GameSettings.serverTitle, GameSettings.motd, GameSettings.description, GameSettings.ListToString(GameSettings.modList), GameSettings.ListToString(GameSettings.adminList), GameSettings.ListToString(GameSettings.bannedList), GameSettings.ListToString(GameSettings.builderList), GameSettings.useBuilderList);
			base.networkView.RPC("SetNewServerID", player, GetServerID());
		}
	}

	public void SendGameServerData(RPCMode mode)
	{
		if (Network.isServer || (localPlayerNode != null && localPlayerNode.isAdmin))
		{
			base.networkView.RPC("ReceiveServerData", mode, GameSettings.serverTitle, GameSettings.motd, GameSettings.description, GameSettings.ListToString(GameSettings.modList), GameSettings.ListToString(GameSettings.adminList), GameSettings.ListToString(GameSettings.bannedList), GameSettings.ListToString(GameSettings.builderList), GameSettings.useBuilderList);
		}
	}

	[RPC]
	private void ReceiveServerData(string title, string MOTD, string description, string modlist, string adminlist, string banlist, string builderList, bool useBuilderList)
	{
		if (Network.isClient)
		{
			GameSettings.port = Network.connections[0].externalPort;
			GameSettings.IP = Network.connections[0].externalIP;
		}
		GameSettings.serverTitle = title;
		GameSettings.description = description;
		GameSettings.motd = MOTD;
		GameSettings.modList = GameSettings.StringToList(modlist);
		GameSettings.adminList = GameSettings.StringToList(adminlist);
		GameSettings.bannedList = GameSettings.StringToList(banlist);
		GameSettings.builderList = GameSettings.StringToList(builderList);
		GameSettings.useBuilderList = useBuilderList;
		ReloadPrivileges();
	}

	public bool GetFinishedLoading()
	{
		return finishedLoading;
	}

	public void SetFinishedLoading()
	{
		finishedLoading = true;
	}

	public List<PlayerNode> GetPlayerList()
	{
		return playerList;
	}

	[RPC]
	public void AddPlayer(NetworkPlayer networkPlayer, string pname, bool boughtGame, int userID, string userSkinID)
	{
		if (GetPlayer(networkPlayer) != null)
		{
			Debug.LogError("AddPlayer: Player already exists!");
			return;
		}
		PlayerNode playerNode = new PlayerNode();
		playerNode.networkPlayer = networkPlayer;
		playerNode.name = pname;
		playerNode.boughtGame = boughtGame;
		playerNode.userID = userID;
		playerNode.userSkinID = userSkinID;
		playerList.Add(playerNode);
		if (Network.player == networkPlayer || string.Concat(Network.player, string.Empty) == "-1")
		{
			playerNode.isLocal = true;
			if (localPlayerNode != null && localPlayerNode.transform != null)
			{
				playerNode.transform = localPlayerNode.transform;
			}
			localPlayerNode = playerNode;
			if (Network.isServer)
			{
				playerNode.isAdmin = true;
				playerNode.isMod = true;
			}
		}
		ReloadPrivileges();
	}

	public void SetPlayersTransform(NetworkPlayer networkPlayer, Transform theTransform)
	{
		if (base.transform == null)
		{
			Debug.LogError("SetPlayersTransform has a NULL transform!");
		}
		PlayerNode player = GetPlayer(networkPlayer);
		if (player == null)
		{
			Debug.LogError("SetPlayersTransform: No player found!");
		}
		player.transform = theTransform;
	}

	[RPC]
	public void RemovePlayer(NetworkPlayer networkPlayer)
	{
		Network.RemoveRPCs(networkPlayer);
		if (Network.isServer)
		{
			Network.DestroyPlayerObjects(networkPlayer);
		}
		PlayerNode player = GetPlayer(networkPlayer);
		if (player != null)
		{
			if ((bool)player.transform)
			{
				Object.Destroy(player.transform.gameObject);
			}
			playerList.Remove(player);
		}
		Resources.UnloadUnusedAssets();
	}

	public PlayerNode GetPlayer(string playerName)
	{
		foreach (PlayerNode player in playerList)
		{
			if (player.name == playerName)
			{
				return player;
			}
		}
		return null;
	}

	public PlayerNode GetPlayer(NetworkPlayer networkPlayer)
	{
		foreach (PlayerNode player in playerList)
		{
			if (player.networkPlayer == networkPlayer)
			{
				return player;
			}
			if (string.Concat(networkPlayer, string.Empty) == "-1" && string.Concat(player.networkPlayer, string.Empty) == "0")
			{
				return player;
			}
		}
		return null;
	}

	public void ServerStarted()
	{
		Statistics.AddStat(Stats.hostedGames, 1);
		Debug.Log("ServerStarted. First save in " + 30 + " seconds, after that every " + 300);
		InvokeRepeating("SaveWorldToDisk", 30f, 300f);
		string username = AccountManager.GetUsername();
		if (username != null && username != string.Empty && username != "Guest")
		{
			if (!GameSettings.adminList.Contains(username))
			{
				GameSettings.adminList.Add(username);
			}
			if (!GameSettings.modList.Contains(username))
			{
				GameSettings.modList.Add(username);
			}
			ReloadPrivileges();
		}
	}

	private void Update()
	{
		if (Network.isServer && Network.maxConnections > 0 && lastRegister + 180f < Time.realtimeSinceStartup)
		{
			lastRegister = Time.realtimeSinceStartup;
			RegisterServer();
		}
	}

	public void SpawnLocalPlayer()
	{
		Vector3 position = base.transform.position;
		Quaternion identity = Quaternion.identity;
		position = WorldData.SP.GetSpawnpoint();
		identity = Quaternion.identity;
		NetworkViewID networkViewID = default(NetworkViewID);
		if (Network.isClient || Network.isServer)
		{
			networkViewID = Network.AllocateViewID();
		}
		SpawnOnNetwork(position, identity, networkViewID, AccountManager.GetUsername(), amOwner: true, Network.player);
		base.networkView.RPC("SpawnOnNetwork", RPCMode.OthersBuffered, position, identity, networkViewID, AccountManager.GetUsername(), false, Network.player);
	}

	[RPC]
	public void SpawnOnNetwork(Vector3 pos, Quaternion rot, NetworkViewID id1, string playerName, bool amOwner, NetworkPlayer np)
	{
		Debug.Log(string.Concat("Spawn at ", pos, " worldsp=", WorldData.SP.GetSpawnpoint()));
		Transform transform = (Transform)Object.Instantiate(playerPrefab, pos, rot);
		SetPlayersTransform(np, transform);
		SetNetworkViewIDs(transform.gameObject, id1);
		PlayerNode player = GetPlayer(np);
		player.playerScript = transform.GetComponent<PlayerScript>();
		player.playerScript.SetPlayerNode(player);
		if (amOwner)
		{
			Object.Destroy(Camera.main.gameObject);
			WorldData.SP.SetLocalPlayer(transform);
		}
	}

	public void SetNetworkViewIDs(GameObject go, NetworkViewID id1)
	{
		Component[] components = go.GetComponents<NetworkView>();
		(components[0] as NetworkView).viewID = id1;
	}

	private void RegisterServer()
	{
		if (Network.isServer && Network.maxConnections > 0)
		{
			int num = (DedicatedServer.isDedicated ? 1 : 0);
			MultiplayerFunctions.SP.RegisterServer(GameSettings.serverTitle, Utils.GetGameVersion() + "#" + num + "#" + ((!GameSettings.useBuilderList) ? "0" : "1") + "#" + ((!(GameSettings.customTerrainFolder == string.Empty)) ? "1" : "0"));
			StartCoroutine(RegisterServerToWeb());
		}
	}

	private IEnumerator RegisterServerToWeb()
	{
		int port = Network.player.port;
		string title = GameSettings.serverTitle;
		string description = GameSettings.description;
		string motd = GameSettings.motd;
		int players = Network.connections.Length;
		int maxPlayers = Network.maxConnections;
		int averagePing = 0;
		int isDedicated = (DedicatedServer.isDedicated ? 1 : 0);
		int gameVersion = Utils.GetGameVersion();
		int useBuilderList = (GameSettings.useBuilderList ? 1 : 0);
		int useCustomTerrain = ((!(GameSettings.customTerrainFolder == string.Empty)) ? 1 : 0);
		NetworkPlayer[] connections = Network.connections;
		foreach (NetworkPlayer player in connections)
		{
			averagePing += Network.GetAveragePing(player);
		}
		averagePing = ((players < 1) ? 100 : (averagePing / players));
		if (isDedicated == 0)
		{
			players++;
			maxPlayers++;
		}
		WWWForm form = new WWWForm();
		form.AddField("action", "ping");
		form.AddField("port", port);
		form.AddField("title", title);
		form.AddField("description", description);
		form.AddField("motd", motd);
		form.AddField("connected", players);
		form.AddField("totalslots", maxPlayers);
		form.AddField("avgping", averagePing);
		form.AddField("dedicated", isDedicated);
		form.AddField("gameversion", gameVersion);
		form.AddField("useBuilderList", useBuilderList);
		form.AddField("useCustomTerrain", useCustomTerrain);
		form.AddField("hasPassword", (!(GameSettings.password == string.Empty)) ? 1 : 0);
		form.AddField("serverID", PlayerPrefs.GetString("serverID_" + GameSettings.port, "0"));
		form.AddField("serverKey", PlayerPrefs.GetString("serverKey_" + GameSettings.port, string.Empty));
		WWW post = new WWW(URL, form);
		yield return post;
		if (post.error != null)
		{
			yield break;
		}
		string[] reply = post.text.Split('#');
		if (reply.Length < 2)
		{
			yield break;
		}
		int newserverID = Utils.SafeIntParse(reply[1], 0);
		if (newserverID != 0)
		{
			base.networkView.RPC("SetNewServerID", RPCMode.All, newserverID);
			PlayerPrefs.SetString("serverID_" + GameSettings.port, newserverID + string.Empty);
			string key = string.Empty;
			if (reply.Length >= 3)
			{
				key = reply[2];
			}
			if (key != string.Empty)
			{
				PlayerPrefs.SetString("serverKey_" + GameSettings.port, key);
			}
		}
	}

	private IEnumerator OnDisconnectedFromServer(NetworkDisconnection info)
	{
		if (Network.isServer)
		{
			MultiplayerFunctions.SP.UnRegisterServer();
			yield return new WaitForSeconds(1f);
			ArrayList listCopy = new ArrayList(playerList);
			{
				foreach (PlayerNode pla in listCopy)
				{
					if (!pla.isLocal)
					{
						RemovePlayer(pla.networkPlayer);
					}
				}
				yield break;
			}
		}
		Debug.Log("Server shutdown");
		if (info == NetworkDisconnection.LostConnection)
		{
			GameSettings.gameHadError = "The server has shut down.";
		}
		StartCoroutine(QuitGame());
		yield return new WaitForSeconds(1f);
		ArrayList listCopy2 = new ArrayList(playerList);
		foreach (PlayerNode pla2 in listCopy2)
		{
			if (!pla2.isLocal)
			{
				RemovePlayer(pla2.networkPlayer);
			}
		}
	}

	[RPC]
	private IEnumerator ResetNetworkViews()
	{
		yield return new WaitForSeconds(10f);
	}

	public bool IsQuitting()
	{
		return quitting;
	}

	public IEnumerator QuitGame()
	{
		if (!quitting)
		{
			Debug.Log("Quitting game");
			quitting = true;
			yield return 0;
			if (Network.isServer)
			{
				yield return StartCoroutine(WorldData.SP.SaveWorld(rightAway: true));
			}
			Network.Disconnect();
			GameSettings.Clear();
			while (Network.peerType != 0)
			{
				yield return 0;
			}
			Application.LoadLevel(Application.loadedLevel - 1);
		}
	}

	private void OnApplicationQuit()
	{
		Debug.Log("GM appquit 1");
		if (!DedicatedServer.isDedicated)
		{
			IENumeratorOutput output = new IENumeratorOutput();
			StartCoroutine(AccountManager.Logout(output));
		}
		else
		{
			DedicatedServer.SaveSettingsToFile();
		}
		if (AccountManager.RealAccount())
		{
			StartCoroutine(Statistics.UploadStats());
		}
		if (Network.isServer)
		{
		}
		Debug.Log("GM OnApplicationQuit - end");
	}

	private void SaveWorldToDisk()
	{
		Debug.Log("SaveWorldToDisk");
		bool rightAway = false;
		if (DedicatedServer.isDedicated)
		{
			rightAway = true;
		}
		StartCoroutine(WorldData.SP.SaveWorld(rightAway));
	}

	public void RunManualSave()
	{
		StartCoroutine(WorldData.SP.SaveWorld(rightAway: true));
	}

	[RPC]
	private void RequestWorldSave(NetworkMessageInfo info)
	{
		PlayerNode player = GetPlayer(info.sender);
		if (IsMod(player))
		{
			RunManualSave();
		}
	}

	[RPC]
	private void SetNewServerID(int newID)
	{
		serverID = newID;
	}

	public int GetServerID()
	{
		return serverID;
	}
}
