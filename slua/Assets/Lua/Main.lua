import "UnityEngine"

local cudeTrans; --transform

local MouseButtonDownAction = function()
    local ray = Camera.main:ScreenPointToRay(Input.mousePosition)
    local hitInfos = Physics.RaycastAll(ray)
    print(#hitInfos)
    if #hitInfos > 0 then
        cudeTrans = hitInfos[1].transform
        print(cudeTrans.position)
    
    end
end

local MouseButtonUpAction = function()
    cubeTrans = nil
end

local MouseButtonAction = function()
    if cudeTrans ~= nil then
        tempV3 = Camera.main:ScreenToWorldPoint(Vector3(Input.mousePosition.x, Input.mousePosition.y, 10));
        cudeTrans.position = tempV3
    end
end

local MouseAxisMoveAction = function(scrollValue)
    cudeTrans.localScale = cudeTrans.localScale + Vector3.one * scrollValue;
end


function main()
--local cube = GameObject.CreatePrimitive(PrimitiveType.Cube)
--cube.transform.position = Camera.main:ScreenToWorldPoint(Vector3(Screen.width/2,Screen.height/2,10));
-- Init.MouseButtonAction = MouseButtonAction
-- Init.MouseButtonDownAction = MouseButtonDownAction
-- Init.MouseButtonUpAction = MouseButtonUpAction
-- Init.MouseAxisMoveAction = MouseAxisMoveAction
end

function Awake()
    require("Object")
    require("ObjectPool")
    
end

function Start()

end

function FixedUpdate()

end

function Update()
end

function LateUpdate()

end

function OnDisable()

end

function OnDestroy()

end
