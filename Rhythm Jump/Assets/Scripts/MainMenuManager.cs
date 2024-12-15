using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MainMenuManager : MonoBehaviour
{
    public GameObject robot1;
    public GameObject robot2;
    [SerializeField] Slider musicSlider;

    // Start is called before the first frame update
    void Awake()
    {
        Time.timeScale = 1;
    }

    // Update is called once per frame
    void Update()
    {
        robot1.transform.Rotate(0.0f, -1.0f, 0.0f, Space.Self);
        robot2.transform.Rotate(0.0f, 1.0f, 0.0f, Space.Self);
    }

    public void LevelOneButton() {
        SceneManager.LoadScene("LevelOne");
    }

    public void LevelTwoButton() {
        SceneManager.LoadScene("LevelTwo");
    }

    public void ExitButton() {
        Application.Quit();
    }

    public void ChangeVolume() {
        AudioListener.volume = musicSlider.value;
    }

}
