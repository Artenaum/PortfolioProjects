using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class GM : MonoBehaviour
{
    public AudioSource song;
    public AudioSource effectsSource;
    public AudioClip explosionSound;
    public GameObject pauseMenu;
    public GameObject levelCompleteMenu;
    public Slider levelSlider;
    public TMP_Text percentText;
    public GameObject player;
    
    bool isPaused = false;
    float percent = 0f;
    // Start is called before the first frame update
    void Awake()
    {
        //StartSong();
    }

    void Start() {
        if (isPaused) {
            UnpauseGame();
        }
        Time.timeScale = 1;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape) || Input.GetKeyDown(KeyCode.P)) {
            if (!isPaused) {
                isPaused = true;
                song.Pause();
                PauseGame();
            }
            else if (isPaused) {
                isPaused = false;
                UnpauseGame();
                song.Play();
            }
        }

        if (player != null) {
            levelSlider.value = player.transform.position.z;
            percent = levelSlider.value / levelSlider.maxValue * 100;
            //Debug.Log(Mathf.RoundToInt(levelSlider.value));
            percent = Mathf.RoundToInt(percent);
            Debug.Log(percent);
            percentText.text = percent.ToString() + "%";
        }
    }

    public void EndGame() {
        Debug.Log("Game ended");
        StopSong();
        effectsSource.PlayOneShot(explosionSound);
        Invoke("RestartGame", 2f);
    }

    public void RestartGame() {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void PauseGame() {
        Time.timeScale = 0;
        pauseMenu.SetActive(true);
    }

    public void UnpauseGame() {
        pauseMenu.SetActive(false);
        Time.timeScale = 1;
    }

    public void BackToMainMenu() {
        SceneManager.LoadScene("MainMenu");
    }

    void StartSong() {
        song.Play();
    }

    void StopSong() {
        song.Stop();
    }

    public void LevelComplete() {
        Time.timeScale = 0;
        levelCompleteMenu.SetActive(true);
    }
}
