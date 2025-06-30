using System.Collections;
using UnityEngine;

public class CharacterViewer : MonoBehaviour
{
	private int m_iUser;

	private string userID = string.Empty;

	public Texture2D cubeLogo;

	public Transform charTrans;

	private void Awake()
	{
		Application.targetFrameRate = 25;
		Application.ExternalCall("TellUserID");
	}

	public void SetUserID(string newID)
	{
		userID = newID;
		int length = userID.IndexOf("_");
		m_iUser = Utils.SafeIntParse(userID.Substring(0, length), 0);
		if (m_iUser != 0)
		{
			StartCoroutine(DownloadSkin());
		}
	}

	private IEnumerator DownloadSkin()
	{
		if (m_iUser == 0)
		{
			yield break;
		}
		WWW www = new WWW("http://skins.cubelands.com/getskin.php?userID=" + userID);
		yield return www;
		if (www.error == null && www.size > 0)
		{
			Renderer[] ren = charTrans.GetComponentsInChildren<Renderer>();
			Renderer[] array = ren;
			foreach (Renderer bl in array)
			{
				bl.material.mainTexture = www.texture;
			}
		}
	}

	private void OnGUI()
	{
		GUI.DrawTexture(new Rect(Screen.width / 2 - 150, 0f, 300f, 100f), cubeLogo, ScaleMode.ScaleToFit);
	}
}
