using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

    public Transform target;
    private Vector3 offset;

    void Start() {
        offset = transform.position - target.position;
    }

    void LateUpdate() {
        if (target != null) {
            Vector3 newPosition = new Vector3(transform.position.x, target.position.y + 1.2f, offset.z + target.position.z);
            transform.position = Vector3.Lerp(transform.position, newPosition, 1f);
        }
    }
}
