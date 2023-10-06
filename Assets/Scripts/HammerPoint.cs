using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class HammerPoint : MonoBehaviour
{
    public Transform hammer;
    public Transform hammerVelocityPoint;
    public float requiredVelocity = 10;

    public UnityEvent SuccessfulHit = new UnityEvent();

    private Vector3 lastPos;
    private float velocity;

    void Start(){
        lastPos = hammerVelocityPoint.position;
    }

    void Update(){
        Vector3 newPos = hammerVelocityPoint.position;
        velocity = Vector3.Distance(newPos,lastPos)/Time.deltaTime;
        lastPos = newPos;
    }

    void OnTriggerEnter(Collider col){
        if(col.transform == hammer || col.transform.IsChildOf(hammer)){
            if(velocity >= requiredVelocity){
                SuccessfulHit.Invoke();
                Destroy(this);
            }
        }
    }
}
