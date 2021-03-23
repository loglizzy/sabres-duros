local function find(v,e)
    return v:FindFirstChild(e)
end

local function get_total(v)
    local total = v.StrengthMulti.Value + v.CoinsMulti.Value
    total = total + v.CrownsMulti.Value
    
    return total
end

local function get_best_pet()
    local data = game:GetService("ReplicatedStorage").Events.UpdateData:InvokeServer()
    local pets = game:GetService("ReplicatedStorage").Pets:GetChildren()
    
    local last
    local last_total
    local last_index
    
    for i,v in pairs(data.PetsInventory) do
        for i,e in pairs(pets) do
            if e.Name == v.PetName then
                v = e
                break
            end
        end
        
        local equipped
        for q,e in pairs(data.PetsEquipped) do
            if q == i then
                equipped = true
            end
        end
        
        local okay = find(v, 'StrengthMulti')
        and find(v, 'CoinsMulti')
        and find(v, 'CrownsMulti')
        
        if v and okay and not equipped  then
            local total = get_total(v)
            
            if last then
                if total > last_total  then
                    last = v
                    last_total = total
                    last_index = i
                    data = game:GetService("ReplicatedStorage").Events.UpdateData:InvokeServer()
                end
            else
                last = v
                last_total = total
                last_index = i
                data = game:GetService("ReplicatedStorage").Events.UpdateData:InvokeServer()
            end
        end
    end
    return last, last_index
end

local function get_worst_pet()
    local data = game:GetService("ReplicatedStorage").Events.UpdateData:InvokeServer()
    local pets = game:GetService("ReplicatedStorage").Pets:GetChildren()
    
    local last
    local last_total
    local last_index
    
    for i,v in pairs(data.PetsEquipped) do
        for q,e in pairs(data.PetsInventory) do
            if q == i then
                v = e
            end
        end
        
        for q,e in pairs(pets) do
            if e.Name == v.PetName then
                v = e
                break
            end
        end
        
        local okay = find(v, 'StrengthMulti')
        and find(v, 'CoinsMulti')
        and find(v, 'CrownsMulti')
    
        if v and okay then
            local total = get_total(v)
            
            if last then
                if total < last_total then
                    last = v
                    last_total = total
                    last_index = i
                end
            else
                last = v
                last_total = total
                last_index = i
            end
        end
    end
    
    return last, last_index
end

local data = game:GetService("ReplicatedStorage").Events.UpdateData:InvokeServer()
local remote = game:GetService("ReplicatedStorage").Events.PetCommand

local a,e = get_best_pet()
local q,f = get_worst_pet()

if a and e and q and f then
    local leng = 0
    for i,v in pairs(data.PetsEquipped) do
        leng = leng + 1
    end
    
    if leng == 3 then
        if get_total(a) > get_total(q) then
            remote:FireServer(f, 'EquipToggle')
            remote:FireServer(e, 'EquipToggle')
        end
    else
        remote:FireServer(e, 'EquipToggle')
    end
end
