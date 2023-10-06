using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lava : MonoBehaviour
{
    public bool flowing = false;
    public bool flowFinished = false;
    public List<GameObject> flow = new List<GameObject>();
    public GameObject lavaFlow;
    private List<GameObject> flows = new List<GameObject>();

    private int currentFlow = 1;
    private float currentTick = 0;

    float defaultLength = 0;

    public void StartFlow(){
        flowing = true;
    }

    void Start(){
        var flowTransform = flow[0].transform;
        defaultLength = Vector3.Distance(flowTransform.Find("StartState").position,flowTransform.Find("EndState").position);
    }

    void FixedUpdate()
    {
        if(!flowing) return;
        if(!flowFinished) FlowTo();
        
    }

    void FlowTo(){
        var currentFlowTransform = flow[currentFlow-1].transform;
        LerpObject(lavaFlow.transform, currentFlowTransform.Find("StartState"),currentFlowTransform.Find("EndState"),currentTick);
        float length = Vector3.Distance(currentFlowTransform.Find("StartState").position,currentFlowTransform.Find("EndState").position);
        if(currentTick >= 1){
            if(currentFlow == 6){flowFinished = true; StopFlow(); return;}
            currentTick = 0;
            currentFlow++;
            flows.Add(lavaFlow);
            lavaFlow.transform.SetParent(transform.Find("ActiveObjects"));
            lavaFlow = GameObject.Instantiate(flow[currentFlow-1].transform.Find("StartState"),transform).gameObject;
            lavaFlow.GetComponent<Renderer>().enabled = true;
        }else{
            currentTick += Time.deltaTime * 0.6f * (defaultLength/length);
        }
    }

    public GameObject sword;
    void StopFlow(){
        sword.SetActive(true);
    }


    void LerpObject(Transform obj1, Transform obj1Origin, Transform obj2, float t){ 
        obj1.position = Vector3.Lerp(obj1Origin.position,obj2.position,t);
        obj1.localScale = Vector3.Lerp(obj1Origin.localScale,obj2.localScale,t);
        obj1.rotation = Quaternion.Lerp(obj1Origin.rotation,obj2.rotation,t);
    }
}
