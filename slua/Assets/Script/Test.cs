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
        //ÿ�ΰ��� ����Ļ��������,������������,��¼����
        //���� ��ǰ���ڳ���ת̬,���Ҽ�¼�����岻Ϊ��,��ô��Ҫ�����������ƶ�
        //ÿ��̧�� ȡ����¼����
    }
    //

}
