using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        print(GetComponent<RectTransform>().anchoredPosition.y);//得到的是PosY的值
        print(GetComponent<RectTransform>().sizeDelta);//得到的Height
        //Image image = GetComponent<Image>();
        print(transform.localPosition);
    }
}
