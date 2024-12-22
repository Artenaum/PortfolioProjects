using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using Photon.Pun;
using Hashtable = ExitGames.Client.Photon.Hashtable;
using Photon.Realtime;

public class PlayerController : MonoBehaviourPunCallbacks, IDamageable {
    [SerializeField] Image healthbarImage;
    [SerializeField] GameObject ui;
    [SerializeField] GameObject disconnectWindow;

    [SerializeField] GameObject eye1, eye2;

    [SerializeField] GameObject cameraHolder;

    [SerializeField] float mouseSensitivity, sprintSpeed, walkSpeed, jumpForce, smoothTime;

    [SerializeField] Item[] items;

    int itemIndex;
    int previousItemIndex = -1;

    float verticalLookRotation;
    bool grounded;
    Vector3 smoothMoveVelocity;
    Vector3 moveAmount;

    Rigidbody rb;

    PhotonView PV;

    const float maxHealth = 100f;
    float currentHealth = maxHealth;

    PlayerManager playerManager;

    bool mouseLocked;
    bool escapeMenuActive = false;

    float useRate = 5;
    float nextUse;

    void Awake() {
        rb = GetComponent<Rigidbody>();
        PV = GetComponent<PhotonView>();

        playerManager = PhotonView.Find((int)PV.InstantiationData[0]).GetComponent<PlayerManager>();
    }

    void Start() {
        if (PV.IsMine) {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
            mouseLocked = true;
            eye1.SetActive(false);
            eye2.SetActive(false);
            EquipItem(0);
        } else {
            Destroy(GetComponentInChildren<Camera>().gameObject);
            Destroy(rb);
            Destroy(ui);
        }
    }

    void Update() {
        if (!PV.IsMine) {
            return;
        }

        if (!escapeMenuActive) {

            Look();
            Move();
            Jump();

            for (int i = 0; i < items.Length; i++) {
                if (Input.GetKeyDown((i + 1).ToString())) {
                    EquipItem(0);
                    break;
                }
            }

            if (Input.GetAxisRaw("Mouse ScrollWheel") > 0f) {
                if (itemIndex >= items.Length - 1) {
                    EquipItem(0);
                } else {
                    EquipItem(0);
                }
            } else if (Input.GetAxisRaw("Mouse ScrollWheel") < 0f) {
                if (itemIndex <= 0) {
                    EquipItem(0);
                } else {
                    EquipItem(0);
                }
            }

            if (Input.GetMouseButton(0) && nextUse <= 0) {
                nextUse = 1 / useRate;
                items[itemIndex].Use();
            }
        }

        if (nextUse > 0)
        nextUse -= Time.deltaTime;

        if (transform.position.y < -10f) {
            Die();
        } 

        if (Input.GetKeyDown(KeyCode.Escape) && !escapeMenuActive) {
            moveAmount = new Vector3(0, 0, 0);
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
            escapeMenuActive = true;
        } else if (Input.GetKeyDown(KeyCode.Escape) && escapeMenuActive) {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
            escapeMenuActive = false;
        }
    }

    void Look() {
        transform.Rotate(Vector3.up * Input.GetAxisRaw("Mouse X") * mouseSensitivity);

        verticalLookRotation += Input.GetAxisRaw("Mouse Y") * mouseSensitivity;
        verticalLookRotation = Mathf.Clamp(verticalLookRotation, -90f, 90f);

        cameraHolder.transform.localEulerAngles = Vector3.left * verticalLookRotation;
    }

    void Move() {
        Vector3 moveDir = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical")).normalized;
        moveAmount = Vector3.SmoothDamp(moveAmount, moveDir * (Input.GetKey(KeyCode.LeftShift) ? sprintSpeed : walkSpeed), ref smoothMoveVelocity, smoothTime);
    }

    void Jump() {
        if (Input.GetKeyDown(KeyCode.Space) && grounded) {
            rb.AddForce(transform.up * jumpForce);
        }
    }

    void EquipItem(int _index) {
        if (_index == previousItemIndex)
            return;

        itemIndex = _index;

        items[itemIndex].itemGameObject.SetActive(true);

        if (previousItemIndex != -1) {
            items[previousItemIndex].itemGameObject.SetActive(false);
        }

        previousItemIndex = itemIndex;

        if (PV.IsMine) {
            Hashtable hash = new Hashtable();
            hash.Add("itemIndex", itemIndex);
            PhotonNetwork.LocalPlayer.SetCustomProperties(hash);
        }
    }

    public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
    {
        if (changedProps.ContainsKey("itemIndex") && !PV.IsMine && targetPlayer == PV.Owner) {
            EquipItem((int)changedProps["itemIndex"]);
        }
    }

    public void SetGroundedState(bool _grounded) {
        grounded = _grounded;
    }

    void FixedUpdate() {
        if (!PV.IsMine) {
            return;
        }

        rb.MovePosition(rb.position + transform.TransformDirection(moveAmount) * Time.fixedDeltaTime);
    }

    public void TakeDamage(float damage) {
        PV.RPC(nameof(RPC_TakeDamage), PV.Owner, damage);
    }

    [PunRPC]
    void RPC_TakeDamage(float damage, PhotonMessageInfo info) {
        currentHealth -= damage;

        healthbarImage.fillAmount = currentHealth / maxHealth;

        if (currentHealth <= 0) {
            Die();
            PlayerManager.Find(info.Sender).GetKill();
        }
    }

    void Die() {
        playerManager.Die();
    }
}
