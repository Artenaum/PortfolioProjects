using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Animations : MonoBehaviour
{
    private Animator animator;
    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
        animator.SetBool("IsJumping", false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayJumpAnimation() {
        animator.SetBool("IsJumping", true);
    }

    public void StopJumpAnimation() {
        animator.SetBool("IsJumping", false);
    }
}
