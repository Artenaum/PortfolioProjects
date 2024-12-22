using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

    private CharacterController controller;
    private Vector3 direction;
    public float speed = 10.386f;

    private int desiredLane = 1; // 0 = left, 1 = middle, 2 = right
    public float laneDistance = 1;

    public float jumpStrength = 10;
    public float jumpPadStrength;
    public float flyPadStrength;
    public float gravity = -20;

    float jumpHeight = 1;
    float oldJumpHeight = 0;
    float jumpLength = 0;
    float initialHeight = 1.726957f;
    float jumpTime;

    public GameObject explosionEffect;
    private Animations animations;

    void Start() {
        controller = GetComponent<CharacterController>();
        animations = GetComponentInChildren<Animations>();
    }

    void Update() {
        direction.z = speed;

        if (controller.isGrounded) {
            animations.StopJumpAnimation();
            if (Input.GetKeyDown(KeyCode.Space)) {
                Jump(jumpStrength);
            }
        } else {
            direction.y += gravity * Time.deltaTime;
            animations.PlayJumpAnimation();
        }

        if (Input.GetKeyDown(KeyCode.RightArrow)) {
            desiredLane++;
            if (desiredLane == 3)
                desiredLane = 2;
        }

        if (Input.GetKeyDown(KeyCode.LeftArrow)) {
            desiredLane--;
            if (desiredLane == -1)
                desiredLane = 0;
        }

        Vector3 targetPosition = transform.position.z * transform.forward + transform.position.y * transform.up;

        if (desiredLane == 0) {
            targetPosition += Vector3.left * laneDistance;
        } else if (desiredLane == 2) {
            targetPosition += Vector3.right * laneDistance;
        }

        controller.Move(direction * Time.deltaTime);
        transform.position = Vector3.Lerp(transform.position, targetPosition, 10f * Time.fixedDeltaTime);
    }

    private void Jump(float strength) {
        direction.y = strength;
        animations.PlayJumpAnimation();
    }

    void OnTriggerEnter(Collider col) {
        if (col.gameObject.tag == "Spike") {
            FindObjectOfType<GM>().EndGame();
            Instantiate(explosionEffect, transform.position, Quaternion.identity);
            Destroy(this.gameObject);
        }
        else if (col.gameObject.tag == "Pad") {
            Jump(jumpPadStrength);
        }
        else if (col.gameObject.tag == "FlyPad") {
            Jump(flyPadStrength);
        }
        else if (col.gameObject.tag == "LevelCompleteTrigger") {
            FindObjectOfType<GM>().LevelComplete();
        }
    }
}
