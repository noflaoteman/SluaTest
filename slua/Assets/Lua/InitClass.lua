--面向对象
require("Object")
--字符串拆分
require("SplitTools")
--Json反序列
Json = require("JsonUtility")

--Unity
GameObject = CS.UnityEngine.GameObject
Camera = CS.UnityEngine.Camera
Input = CS.UnityEngine.Input
Resources = CS.UnityEngine.Resources
Transform = CS.UnityEngine.Transform
RectTransform = CS.UnityEngine.RectTransform
RectTransformUtility = CS.UnityEngine.RectTransformUtility
TextAsset = CS.UnityEngine.TextAsset
SpriteAtlas = CS.UnityEngine.U2D.SpriteAtlas
Vector3 = CS.UnityEngine.Vector3
Vector2 = CS.UnityEngine.Vector2

--UI
UI = CS.UnityEngine.UI
CanvasGroup = CS.UnityEngine.CanvasGroup
Image = UI.Image
Text = UI.Text
Button = UI.Button
Toggle = UI.Toggle
ScrollRect = UI.ScrollRect
UIBehaviour = CS.UnityEngine.EventSystems.UIBehaviour
EventTrigger = CS.UnityEngine.EventSystems.EventTrigger
BaseEventData = CS.UnityEngine.EventSystems.BaseEventData
PointerEventData = CS.UnityEngine.EventSystems.PointerEventData
Entry = CS.UnityEngine.EventSystems.EventTrigger.Entry

Canvas = GameObject.Find("Canvas").transform
ABMgr = CS.ABMgr.GetInstance()
InputManager = CS.InputManager.GetInstance()
