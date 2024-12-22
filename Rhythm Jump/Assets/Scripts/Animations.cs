using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Animations : MonoBehaviour {

    private Animator animator;

    void Start() {
        animator = GetComponent<Animator>();
        animator.SetBool("IsJumping", false);
    }

    public void PlayJumpAnimation() {
        animator.SetBool("IsJumping", true);
    }

    public void StopJumpAnimation() {
        animator.SetBool("IsJumping", false);
    }
}
