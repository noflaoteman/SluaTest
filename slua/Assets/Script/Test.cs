using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x,Input.mousePosition.y,20));
        RaycastHit[] hitInfos =  Physics.RaycastAll(ray.origin,ray.direction,100);

        //transform.position
        //hitInfos[1].transform;
        //transform.localScale = 
        Debug.DrawRay(ray.origin, ray.direction);
        Input.GetMouseButton(0);
        Input.GetMouseButtonDown(0);
        Input.GetMouseButtonUp(0);
        //每次按下 从屏幕发射摄像,若击中了物体,记录物体
        //长按 当前处于长按转态,并且记录的物体不为空,那么就要物体跟着鼠标移动
        //每次抬起 取消记录物体
    }
    //

}
