using System.Collections;
using System.Collections.Generic;
using LitJson;
using UnityEngine;

public class AccountManager : MonoBehaviour
{
	private static bool isGuest = false;

	private static int userID;

	private static string username;

	private static string userSkinID;

	private static string userEmail;

	private static string sessionKey;

	private static bool boughtGame;

	private static bool hasDoneTutorial = false;

	private static List<Friend> friendsList = new List<Friend>();

	private static List<Friend> pendingFriends = new List<Friend>();

	private static List<Friend> friendInvites = new List<Friend>();

	private static string wwwURL = "http://gamedata.cubelands.com/accounts.php";

	public static bool IsGuest()
	{
		return isGuest;
	}

	public static bool LoggedIn()
	{
		return userID > 0 || IsGuest();
	}

	public static bool RealAccount()
	{
		return userID > 0;
	}

	public static MonoBehaviour GetMono()
	{
		if (Application.loadedLevel == 1)
		{
			return MainMenu.SP;
		}
		return GameManager.SP;
	}

	public static IEnumerator Login(IENumeratorOutput output, string loginName, string password)
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "login");
		form.AddField("loginName", loginName);
		form.AddField("pasW", password);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			output.SetFailed();
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			output.SetFailed();
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			output.SetFailed();
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Login failed");
			output.SetFailed();
		}
		else if (((string)jsonObj["userID"]).Length > 0)
		{
			int theUserID = int.Parse(string.Concat(jsonObj["userID"], string.Empty));
			string sessionK = string.Concat(jsonObj["sessionKey"], string.Empty);
			string usern = string.Concat(jsonObj["username"], string.Empty);
			string email = string.Concat(jsonObj["email"], string.Empty);
			hasDoneTutorial = (string)jsonObj["doneTutorial"] == "1";
			boughtGame = (string)jsonObj["boughtGame"] == "1";
			int pos = returnedString.IndexOf("userSkinID");
			if (pos > 0)
			{
				userSkinID = string.Concat(jsonObj["userSkinID"], string.Empty);
			}
			else
			{
				userSkinID = string.Empty;
			}
			if (!boughtGame && Utils.IsStandalone())
			{
				output.SetOutput("buygame");
				yield break;
			}
			LoggedIn(theUserID, usern, email, sessionK);
			output.SetOutput("succes");
			friendsList = new List<Friend>();
		}
		else
		{
			output.SetOutput("wrongpassword");
		}
	}

	public static IEnumerator WebLogin(IENumeratorOutput output, int webUserID, string webSessionKey, string passwordPart)
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "weblogin");
		form.AddField("userID", webUserID);
		form.AddField("webSessionKey", webSessionKey);
		form.AddField("pass", passwordPart);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		Debug.Log(www.text);
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			output.SetFailed();
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			output.SetFailed();
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			output.SetFailed();
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Login failed");
			output.SetFailed();
			yield break;
		}
		Debug.Log("WebLogin: " + returnedString);
		if (((string)jsonObj["userID"]).Length > 0)
		{
			int theUserID = int.Parse(string.Concat(jsonObj["userID"], string.Empty));
			string sessionK = string.Concat(jsonObj["sessionKey"], string.Empty);
			string usern = string.Concat(jsonObj["username"], string.Empty);
			string email = string.Concat(jsonObj["email"], string.Empty);
			hasDoneTutorial = (string)jsonObj["doneTutorial"] == "1";
			boughtGame = (string)jsonObj["boughtGame"] == "1";
			int pos = returnedString.IndexOf("userSkinID");
			Debug.Log("Pos = " + pos);
			if (pos > 0)
			{
				userSkinID = string.Concat(jsonObj["userSkinID"], string.Empty);
			}
			else
			{
				userSkinID = string.Empty;
			}
			LoggedIn(theUserID, usern, email, sessionK);
			output.SetOutput("succes");
		}
		else
		{
			output.SetOutput("wrongpassword");
		}
	}

	public static IEnumerator AddFriend(int friendID, string friendName)
	{
		if (FriendListContains(friendName, pendingFriends))
		{
			yield break;
		}
		WWWForm form = new WWWForm();
		form.AddField("action", "addfriend");
		form.AddField("userID", userID);
		form.AddField("friendID", friendID);
		form.AddField("friendName", friendName);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			yield break;
		}
		string returnedString = www.text;
		Debug.Log("AddFriend" + friendID + " " + friendName + " =" + returnedString);
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			yield break;
		}
		GetMono().StartCoroutine(FetchFriends());
		GetMono().StartCoroutine(FetchFriendInvites());
		GetMono().StartCoroutine(FetchPendingFriends());
	}

	public static IEnumerator DeleteFriend(int friendID, string friendName)
	{
		if (friendName != string.Empty && !FriendListContains(friendName, friendInvites) && !FriendListContains(friendName, pendingFriends) && !FriendListContains(friendName, friendsList))
		{
			yield break;
		}
		WWWForm form = new WWWForm();
		form.AddField("action", "deletefriend");
		form.AddField("userID", userID);
		form.AddField("friendID", friendID);
		form.AddField("friendName", friendName);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			yield break;
		}
		string returnedString = www.text;
		Debug.Log("DeleteFriend" + friendID + " " + friendName + " =" + returnedString);
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			yield break;
		}
		GetMono().StartCoroutine(FetchFriends());
		GetMono().StartCoroutine(FetchFriendInvites());
		GetMono().StartCoroutine(FetchPendingFriends());
	}

	public static IEnumerator FetchFriends()
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "getfriends");
		form.AddField("userID", userID);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Fetch friends failed");
			yield break;
		}
		friendsList = new List<Friend>();
		JsonData jsonObjFriends = jsonObj["Friends"];
		for (int i = 0; i < jsonObjFriends.Count; i++)
		{
			JsonData friend = jsonObjFriends[i];
			Friend fr = new Friend
			{
				userID = int.Parse(string.Concat(friend["friendID"], string.Empty)),
				name = string.Concat(friend["username"], string.Empty),
				isOnline = ((string)friend["isOnline"] == "1"),
				lastIP = string.Concat(friend["lastServerIP"], string.Empty),
				lastPort = int.Parse(string.Concat(friend["lastServerPort"], string.Empty)),
				lastLogin = string.Concat(friend["lastLogin"], string.Empty)
			};
			friendsList.Add(fr);
		}
		friendsList.Sort(new FriendsSorter());
	}

	public static IEnumerator FetchPendingFriends()
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "getpendingfriends");
		form.AddField("userID", userID);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Fetch friends failed");
			yield break;
		}
		pendingFriends = new List<Friend>();
		JsonData jsonObjFriends = jsonObj["Friends"];
		for (int i = 0; i < jsonObjFriends.Count; i++)
		{
			JsonData friend = jsonObjFriends[i];
			Friend fr = new Friend
			{
				userID = int.Parse(string.Concat(friend["friendID"], string.Empty)),
				name = string.Concat(friend["username"], string.Empty)
			};
			pendingFriends.Add(fr);
		}
	}

	public static IEnumerator FetchFriendInvites()
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "getfriendinvites");
		form.AddField("userID", userID);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data" + returnedString);
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Fetch friends failed");
			yield break;
		}
		friendInvites = new List<Friend>();
		JsonData jsonObjFriends = jsonObj["Friends"];
		for (int i = 0; i < jsonObjFriends.Count; i++)
		{
			JsonData friend = jsonObjFriends[i];
			Friend fr = new Friend
			{
				userID = int.Parse(string.Concat(friend["friendID"], string.Empty)),
				name = string.Concat(friend["username"], string.Empty)
			};
			friendInvites.Add(fr);
		}
		int count = friendInvites.Count;
		if (count > 0)
		{
			Notifications.AddNotification("New friend requests", "You have " + count + " new friend request(s)!", NotificationTypes.NewFriendInvites);
		}
	}

	public static List<Friend> GetPendingFriends()
	{
		return pendingFriends;
	}

	public static List<Friend> GetFriendInvites()
	{
		return friendInvites;
	}

	public static List<Friend> GetFriends()
	{
		return friendsList;
	}

	public static bool HasFriend(string name)
	{
		return FriendListContains(name, friendsList);
	}

	public static bool FriendListContains(string name, List<Friend> fList)
	{
		foreach (Friend f in fList)
		{
			if (name == f.name)
			{
				return true;
			}
		}
		return false;
	}

	public static IEnumerator Register(IENumeratorOutput output, string username, string email, string password)
	{
		if (password.Length < 5)
		{
			output.SetOutput("The password must be at least 5 characters long");
			yield break;
		}
		WWWForm form = new WWWForm();
		form.AddField("action", "register");
		form.AddField("username", username);
		form.AddField("email", email);
		form.AddField("pasW", Utils.Md5Sum(password.ToLower() + "mySEED"));
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			output.SetFailed();
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data");
			output.SetFailed();
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			output.SetFailed();
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		Debug.Log(jsonData);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Login failed");
			output.SetFailed();
			yield break;
		}
		string result = (string)jsonObj["result"];
		if (result == string.Empty)
		{
			TextAsset bla = (TextAsset)Resources.Load("defaultWorld", typeof(TextAsset));
			if (PlayerPrefs.GetString("MyWorld", string.Empty) == string.Empty)
			{
				PlayerPrefs.SetString("MyWorld", bla.text);
			}
			int theUserID = int.Parse(string.Concat(jsonObj["userID"], string.Empty));
			string sessionK = string.Concat(jsonObj["sessionKey"], string.Empty);
			hasDoneTutorial = false;
			LoggedIn(theUserID, username, email, sessionK);
			output.SetOutput("succes");
		}
		else
		{
			output.SetOutput(result);
		}
	}

	public static IEnumerator Ping(IENumeratorOutput output)
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "ping");
		form.AddField("userID", userID);
		form.AddField("sessionKey", sessionKey);
		string serverIP = string.Empty;
		string serverPort = string.Empty;
		if (Network.isClient)
		{
			serverIP = Network.connections[0].externalIP;
			serverPort = Network.connections[0].externalPort + string.Empty;
		}
		else if (Network.isServer)
		{
			serverPort = GameSettings.port + string.Empty;
			serverIP = "localhost";
		}
		form.AddField("serverIP", serverIP);
		form.AddField("serverPort", serverPort);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			output.SetFailed();
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data");
			output.SetFailed();
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			output.SetFailed();
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Login failed");
			output.SetFailed();
		}
		else if (int.Parse(string.Concat(jsonObj["result"], string.Empty)) != 1)
		{
			output.SetOutput(int.Parse(string.Concat(jsonObj["result"], string.Empty)));
			output.SetFailed();
		}
	}

	public static IEnumerator Logout(IENumeratorOutput output)
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "logout");
		form.AddField("userID", userID);
		form.AddField("sessionKey", sessionKey);
		WWW www = new WWW(wwwURL, form);
		yield return www;
		Loggedout();
		if (www.error != null)
		{
			Debug.LogError("ERROR: WWW call failed!");
			output.SetFailed();
			yield break;
		}
		string returnedString = www.text;
		if (returnedString == null || returnedString == string.Empty)
		{
			Debug.LogError("ERROR: WWW had invalid return data");
			output.SetFailed();
			yield break;
		}
		if (returnedString.Substring(0, 1) != "1")
		{
			Debug.LogError("ERROR: WWW had invalid return data; not 1" + returnedString);
			output.SetFailed();
			yield break;
		}
		string jsonData = returnedString.Substring(1);
		JsonData jsonObj = JsonMapper.ToObject(jsonData);
		if (jsonObj == null)
		{
			Debug.LogError("Login failed");
			output.SetFailed();
		}
		else if (int.Parse(string.Concat(jsonObj["result"], string.Empty)) != 1)
		{
			output.SetFailed();
		}
	}

	public static void GuestLoggedin(string usr)
	{
		isGuest = true;
		userID = 0;
		username = usr;
		userEmail = string.Empty;
		sessionKey = string.Empty;
		hasDoneTutorial = PlayerPrefs.GetInt("didTut_" + usr, 0) == 1;
		boughtGame = false;
	}

	public static void LoggedIn(int newUserID, string newUserName, string email, string sesK)
	{
		if (Utils.IsCubelandsHosted())
		{
			Application.ExternalEval("if(window.location.host.indexOf(\"classic.cubelands.com\")==0){ GameLogin(" + newUserID + ",\"" + sesK + "\"); }");
		}
		isGuest = false;
		userID = newUserID;
		username = newUserName;
		userEmail = email;
		sessionKey = sesK;
		if (GetMono() != null)
		{
			GetMono().StartCoroutine(FetchFriends());
			GetMono().StartCoroutine(FetchFriendInvites());
			GetMono().StartCoroutine(FetchPendingFriends());
		}
	}

	public static void Loggedout()
	{
		isGuest = false;
		userID = -1;
		username = (sessionKey = string.Empty);
	}

	public static string GetUsername()
	{
		return username;
	}

	public static int GetUserID()
	{
		if (IsGuest())
		{
			Debug.LogWarning("GetUSERID on guest!");
			return 0;
		}
		return userID;
	}

	public static string GetUserSkinID()
	{
		return userSkinID;
	}

	public static string GetSessionKey()
	{
		if (IsGuest())
		{
			Debug.LogError("GetSessionKey on guest!");
			return "00000000000000000000";
		}
		return sessionKey;
	}

	public static string GetEmail()
	{
		if (IsGuest())
		{
			return "Guest";
		}
		return userEmail;
	}

	public static bool DidTutorial()
	{
		return hasDoneTutorial;
	}

	public static void JustFinishedTutorial()
	{
		hasDoneTutorial = true;
	}

	public static bool BoughtGame()
	{
		return boughtGame;
	}
}
