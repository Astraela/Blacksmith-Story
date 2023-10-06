using System.Collections;
using System.Collections.Generic;
using Tilia.Interactions.Interactables.Interactables;
using UnityEngine.Events;
using UnityEngine;

public class StupidAssScriptToDisableTwiceDoing : MonoBehaviour
{
    public Highlighter highlighter;
    // Start is called before the first frame update
    void Start()
    {
        foreach (var obj in highlighter.order)
        {
            if(obj.GetComponentInChildren<InteractableFacade>()){
                var interactable = obj.GetComponentInChildren<InteractableFacade>();
                interactable.FirstGrabbed.AddListener(delegate{remove(interactable);});
            }
        }
    }

    public void remove(InteractableFacade interactable){
        try
        {
            for (int i = 0; i < 10; i++)
            {
                //UnityEventTools.RemovePersistentListener(interactable.FirstGrabbed, 0);
                interactable.FirstGrabbed.SetPersistentListenerState(i,UnityEventCallState.Off);
            }
        }
        catch (System.Exception)
        {
            
        }
        interactable.FirstGrabbed.RemoveAllListeners();
        print("Listeners removed");
    }

    public void remove(HammerPoint interactable){
        Destroy(interactable);
    }
}
