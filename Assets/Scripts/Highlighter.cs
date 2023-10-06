using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Highlighter : MonoBehaviour
{
    public Material highlight;
    public List<GameObject> order;
    
    public float distanceCheck = 10;

    private float duration = 1.2f;

    void Start(){
        Highlight(order[0]);
    }

    void Update()
    {
        var color = highlight.GetColor("_TintColor");
        color.a = Mathf.Lerp(0.08f,.04f,Mathf.PingPong(Time.time/duration,1));
        highlight.SetColor("_TintColor",color);
        
        if(order.Count == 0) return;
        var distance = Vector3.Distance(Camera.main.transform.position,order[0].transform.position);
        if(distance <= distanceCheck){
            highlight.SetFloat("_SeeThru",.8f);
        }else{
            highlight.SetFloat("_SeeThru",0);
        }
    }

    public void changeDistanceCheck(float nr){
        distanceCheck = nr;
    }

    void Highlight(GameObject obj){
        foreach(Renderer renderer in obj.GetComponentsInChildren<Renderer>()){
            var materials = renderer.materials;
            var newMaterials = new Material[materials.Length+1];
            materials.CopyTo(newMaterials,0);
            newMaterials[newMaterials.Length-1] = highlight;
            renderer.materials = newMaterials;
        }
    }

    void UnHighlight(GameObject obj){
        foreach(Renderer renderer in obj.GetComponentsInChildren<Renderer>()){
            var materials = renderer.materials;
            Array.Resize(ref materials,materials.Length-1);
            renderer.materials = materials;
        }
    }

    private bool ffadb = false;

    public void FullfillAction(GameObject sender){
        print(sender.name);
        FullfillAction();
    }

    public void FullfillAction(){
        if(ffadb)return;
        ffadb = true;
        //print(Time.time);
        if(order.Count == 0) return;
        UnHighlight(order[0]);
        order.Remove(order[0]);
        if(order.Count == 0) return;
        Highlight(order[0]);
        ffadb = false;
    }

}
