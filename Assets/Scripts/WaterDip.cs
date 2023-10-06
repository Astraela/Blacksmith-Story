using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
public class WaterDip : MonoBehaviour
{
    public Transform sword;
    public UnityEvent successfulDip =new UnityEvent();

    bool dipped = false;
    public void Dip(){
        if(Vector3.Distance(sword.position,transform.position) <= 1){
            sword.Find("MeshContainer").Find("COLD").gameObject.SetActive(true);
            sword.Find("MeshContainer").Find("HOT").gameObject.SetActive(false);
            successfulDip.Invoke();
            Destroy(this);
        }
    }

    bool db = false;
    void OnTriggerEnter(Collider col){
        if(db)return;
        db=true;
        if(col.transform.IsChildOf(GameObject.Find("CameraRigs.TrackedAlias").transform)){
            Dip();
        }
        db=false;
    }
}
