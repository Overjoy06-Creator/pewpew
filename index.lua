--==[[ libs ]]==--

string.format = function(s, tab) return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)) end

string.split = function(s, delimiter)
    result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

table.tostring = function(tbl, depth)
    local res = "{"
    local prev = 0
    for k, v in next, tbl do
        if type(v) == "table" then
            if depth == nil or depth > 0 then
                res =
                    res ..
                    ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") ..
                        table.tostring(v, depth and depth - 1 or nil) .. ", "
            else
                res = res .. k .. ":  {...}, "
            end
        else
            res = res .. ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") .. tostring(v) .. ", "
        end
        prev = type(k) == "number" and k or nil
    end
    return res:sub(1, res:len() - 2) .. "}"
end

-- [[Timers4TFM]] --
local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a

--[[DataHandler v22]]
local a={}a.VERSION='1.5'a.__index=a;function a.new(b,c,d)local self=setmetatable({},a)assert(b,'Invalid module ID (nil)')assert(b~='','Invalid module ID (empty text)')assert(c,'Invalid skeleton (nil)')for e,f in next,c do f.type=f.type or type(f.default)end;self.players={}self.moduleID=b;self.moduleSkeleton=c;self.moduleIndexes={}self.otherOptions=d;self.otherData={}self.originalStuff={}for e,f in pairs(c)do self.moduleIndexes[f.index]=e end;if self.otherOptions then self.otherModuleIndexes={}for e,f in pairs(self.otherOptions)do self.otherModuleIndexes[e]={}for g,h in pairs(f)do h.type=h.type or type(h.default)self.otherModuleIndexes[e][h.index]=g end end end;return self end;function a.newPlayer(self,i,j)assert(i,'Invalid player name (nil)')assert(i~='','Invalid player name (empty text)')self.players[i]={}self.otherData[i]={}j=j or''local function k(l)local m={}for n in string.gsub(l,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',',')if string.match(n,'^{.-}$')then table.insert(m,k(string.match(n,'^{(.-)}$')))else table.insert(m,tonumber(n)or n)end end;return m end;local function p(c,q)for e,f in pairs(c)do if f.index==q then return e end end;return 0 end;local function r(c)local s=0;for e,f in pairs(c)do if f.index>s then s=f.index end end;return s end;local function t(b,c,u,v)local w=1;local x=r(c)b="__"..b;if v then self.players[i][b]={}end;local function y(n,z,A,B)local C;if z=="number"then C=tonumber(n)or B elseif z=="string"then C=string.match(n and n:gsub('\\"','"')or'',"^\"(.-)\"$")or B elseif z=="table"then C=string.match(n or'',"^{(.-)}$")C=C and k(C)or B elseif z=="boolean"then if n then C=n=='1'else C=B end end;if v then self.players[i][b][A]=C else self.players[i][A]=C end end;if#u>0 then for n in string.gsub(u,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',','):gsub('\9',',')local A=p(c,w)local z=c[A].type;local B=c[A].default;y(n,z,A,B)w=w+1 end end;if w<=x then for D=w,x do local A=p(c,D)local z=c[A].type;local B=c[A].default;y(nil,z,A,B)end end end;local E,F=self:getModuleData(j)self.originalStuff[i]=F;if not E[self.moduleID]then E[self.moduleID]='{}'end;t(self.moduleID,self.moduleSkeleton,E[self.moduleID]:sub(2,-2),false)if self.otherOptions then for b,c in pairs(self.otherOptions)do if not E[b]then local G={}for e,f in pairs(c)do local z=f.type or type(f.default)if z=='string'then G[f.index]='"'..tostring(f.default:gsub('"','\\"'))..'"'elseif z=='table'then G[f.index]='{}'elseif z=='number'then G[f.index]=f.default elseif z=='boolean'then G[f.index]=f.default and'1'or'0'end end;E[b]='{'..table.concat(G,',')..'}'end end end;for b,u in pairs(E)do if b~=self.moduleID then if self.otherOptions and self.otherOptions[b]then t(b,self.otherOptions[b],u:sub(2,-2),true)else self.otherData[i][b]=u end end end end;function a.dumpPlayer(self,i)local m={}local function H(I)local m={}for e,f in pairs(I)do local J=type(f)if J=='table'then m[#m+1]='{'m[#m+1]=H(f)if m[#m]:sub(-1)==','then m[#m]=m[#m]:sub(1,-2)end;m[#m+1]='}'m[#m+1]=','else if J=='string'then m[#m+1]='"'m[#m+1]=f:gsub('"','\\"')m[#m+1]='"'elseif J=='boolean'then m[#m+1]=f and'1'or'0'else m[#m+1]=f end;m[#m+1]=','end end;if m[#m]==','then m[#m]=''end;return table.concat(m)end;local function K(i,b)local m={b,'=','{'}local L=self.players[i]local M=self.moduleIndexes;local N=self.moduleSkeleton;if self.moduleID~=b then M=self.otherModuleIndexes[b]N=self.otherOptions[b]b='__'..b;L=self.players[i][b]end;if not L then return''end;for D=1,#M do local A=M[D]local z=N[A].type;if z=='string'then m[#m+1]='"'m[#m+1]=L[A]:gsub('"','\\"')m[#m+1]='"'elseif z=='number'then m[#m+1]=L[A]elseif z=='boolean'then m[#m+1]=L[A]and'1'or'0'elseif z=='table'then m[#m+1]='{'m[#m+1]=H(L[A])m[#m+1]='}'end;m[#m+1]=','end;if m[#m]==','then m[#m]='}'else m[#m+1]='}'end;return table.concat(m)end;m[#m+1]=K(i,self.moduleID)if self.otherOptions then for e,f in pairs(self.otherOptions)do local u=K(i,e)if u~=''then m[#m+1]=','m[#m+1]=u end end end;for e,f in pairs(self.otherData[i])do m[#m+1]=','m[#m+1]=e;m[#m+1]='='m[#m+1]=f end;return table.concat(m)..self.originalStuff[i]end;function a.get(self,i,A,O)if not O then return self.players[i][A]else assert(self.players[i]['__'..O],'Module data not available ('..O..')')return self.players[i]['__'..O][A]end end;function a.set(self,i,A,C,O)if O then self.players[i]['__'..O][A]=C else self.players[i][A]=C end;return self end;function a.save(self,i)system.savePlayerData(i,self:dumpPlayer(i))end;function a.removeModuleData(self,i,O)assert(O,"Invalid module name (nil)")assert(O~='',"Invalid module name (empty text)")assert(O~=self.moduleID,"Invalid module name (current module data structure)")if self.otherData[i][O]then self.otherData[i][O]=nil;return true else if self.otherOptions and self.otherOptions[O]then self.players[i]['__'..O]=nil;return true end end;return false end;function a.getModuleData(self,l)local m={}for b,u in string.gmatch(l,'([0-9A-Za-z_]+)=(%b{})')do local P=self:getTextBetweenQuotes(u:sub(2,-2))for D=1,#P do P[D]=P[D]:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")u=u:gsub(P[D],P[D]:gsub(',','\9'))end;m[b]=u end;for e,f in pairs(m)do l=l:gsub(e..'='..f:gsub('\9',','):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")..',?','')end;return m,l end;function a.convertFromOld(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'?')local m={}for D=1,#E do local O=E[D]:match('([0-9a-zA-Z]+)=')local u=S(E[D]:gsub(O..'=',''):gsub(',,',',\8,'),',')local G={}for V=1,#u do if R[O][V]then if R[O][V]=='table'then G[#G+1]='{'if u[V]~='\8'then local I=S(u[V],'#')for W=1,#I do G[#G+1]=I[W]G[#G+1]=','end;if G[#G]==','then table.remove(G)end end;G[#G+1]='},'elseif R[O][V]=='string'then G[#G+1]='"'if u[V]~='\8'then G[#G+1]=u[V]end;G[#G+1]='"'G[#G+1]=','else if u[V]~='\8'then G[#G+1]=u[V]else G[#G+1]=0 end;G[#G+1]=','end end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'m[#m+1]=','end;if m[#m]==','then table.remove(m)end;return table.concat(m)end;function a.convertFromDataManager(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'§')local m={}for D=1,#E do local O=E[D]:match('%[(.-)%]')local u=S(E[D]:gsub('%['..O..'%]%((.-)%)','%1'),'#')local G={}for V=1,#u do if R[V]=='table'then local I=S(u[V],'&')G[#G+1]='{'for W=1,#I do if tonumber(I[W])then G[#G+1]=I[W]G[#G+1]=','else G[#G+1]='"'G[#G+1]=I[W]G[#G+1]='"'G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;G[#G+1]='}'G[#G+1]=','else if R[V]=='string'then G[#G+1]='"'G[#G+1]=u[V]G[#G+1]='"'else G[#G+1]=u[V]end;G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'end;return table.concat(m)end;function a.getTextBetweenQuotes(self,l)local m={}local X=1;local Y=0;local Z=false;for D=1,#l do local _=l:sub(D,D)if _=='"'then if l:sub(D-1,D-1)~='\\'then if Y==0 then X=D;Y=Y+1 else Y=Y-1;if Y==0 then m[#m+1]=l:sub(X,D)end end end end end;return m end;DataHandler=a


--==[[ init ]]==--

tfm.exec.disableAutoNewGame()
tfm.exec.disableAutoScore()
tfm.exec.disableAutoShaman()
tfm.exec.disableAutoTimeLeft()

local maps = {521833, 401421, 541917, 541928, 541936, 541943, 527935, 559634, 559644, 888052, 878047, 885641, 770600, 770656, 772172, 891472, 589736, 589800, 589708, 900012, 901062, 754380, 901337, 901411, 892660, 907870, 910078, 1190467, 1252043, 1124380, 1016258, 1252299, 1255902, 1256808, 986790, 1285380, 1271249, 1255944, 1255983, 1085344, 1273114, 1276664, 1279258, 1286824, 1280135, 1280342, 1284861, 1287556, 1057753, 1196679, 1288489, 1292983, 1298164, 1298521, 1293189, 1296949, 1308378, 1311136, 1314419, 1314982, 1318248, 1312411, 1312589, 1312845, 1312933, 1313969, 1338762, 1339474, 1349878, 1297154, 644588, 1351237, 1354040, 1354375, 1362386, 1283234, 1370578, 1306592, 1360889, 1362753, 1408124, 1407949, 1407849, 1343986, 1408028, 1441370, 1443416, 1389255, 1427349, 1450527, 1424739, 869836, 1459902, 1392993, 1426457, 1542824, 1533474, 1561467, 1563534, 1566991, 1587241, 1416119, 1596270, 1601580, 1525751, 1582146, 1558167, 1420943, 1466487, 1642575, 1648013, 1646094, 1393097, 1643446, 1545219, 1583484, 1613092, 1627981, 1633374, 1633277, 1633251, 1585138, 1624034, 1616785, 1625916, 1667582, 1666996, 1675013, 1675316, 1531316, 1665413, 1681719, 1699880, 1688696, 623770, 1727243, 1531329, 1683915, 1689533, 1738601, 3756146}

local items = {
    1,  -- small box
    2,  -- large box
    3,  -- small plank
    4,  -- large plank
    6,  -- ball
    10, -- anvil
    23, -- bomb
    24, -- spirit
    28, -- blueBaloon
    32, -- rune
    34, -- snow ball
    35, -- cupid arrow
    39, -- apple
    40, -- sheep
    45, -- small ice plank
    46, -- small choco plank
    54, -- ice cube
    57, -- cloud
    59, -- bubble
    60, -- tiny plank
    62, -- stable rune
    65, -- puffer fish
    90  -- tombstone
}

local assets = {
    banner = "173f1aa1720.png",
    count1 = "173f211056a.png",
    count2 = "173f210937b.png",
    count3 = "173f210089f.png",
    newRound = "173f2113b5e.png",
    heart = "173f2212052.png",
    items = {
        [1] = "172514f2882.png",
        [2] = "174068e3bca.png", -- large box
        [3] = "172514f2882.png",
        [4] = "172514f2882.png",
        [6] = "172514f110f.png",
        [10] = "172514f2882.png",
        [17] = "173f5c17582.png", -- cannon
        [23] = "172514f2882.png",
        [24] = "172514f2882.png",
        [28] = "172514f2882.png",
        [32] = "172514f2882.png",
        [34] = "172514f2882.png",
        [35] = "172514f2882.png",
        [39] = "172514f2882.png",
        [40] = "172514f2882.png",
        [45] = "172514f2882.png",
        [46] = "172514f2882.png",
        [54] = "172514f2882.png",
        [57] = "172514f2882.png",
        [59] = "172514f2882.png",
        [60] = "172514f2882.png",
        [62] = "172514f2882.png",
        [65] = "172514f2882.png",
        [90] = "172514f2882.png"
    }
}

local closeSequence = {
    [1] = {}
}

local dHandler = DataHandler.new("pew", {
    rounds = {
        index = 1,
        type = "number",
        default = 0
    },
    survived = {
        index = 2,
        type = "number",
        default = 0
    },
    won = {
        index = 3,
        type = "number",
        default = 0
    }
})

local initialized, newRoundStarted, suddenDeath = false
local currentItem = 2 -- cannon


--==[[ translations ]]==--

local translations = {}

translations["en"] = {	
	LIVES_LEFT =	"<ROSE>You have <N>${lives} <ROSE>lives left. <VI>Respawning in 3...",	
	LOST_ALL =	"<ROSE>You have lost all your lives!",	
	SD =		"<VP>Sudden death! Everyone has <N>1 <VP>life left",	
	WELCOME =	"<VP>Welcome to pewpew, <N>duck <VP>or <N>spacebar <VP>to shoot items!",	
	SOLE =		"<ROSE>${player} is the sole survivor!"
}

translations["br"] = {        
	LIVES_LEFT =    "<ROSE>Você possuí<N>${lives} <ROSE>vidas restantes. <VI>Renascendo em 3...",        
	LOST_ALL =      "<ROSE>Você perdeu todas as suas vidas!",        
	SD =            "<VP>Morte Súbita! Todos agora possuem <N>1 <VP>vida restante",        
	WELCOME =       "<VP>Bem vindo ao pewpew, <N>use a seta para baixo <VP>ou <N> a barra de espaço <VP>para atirar itens!",        
	SOLE =          "<ROSE>${player} é o último sobrevivente!"
}

translations["es"] = {        
	LIVES_LEFT =    "<ROSE>Te quedan <N>${lives} <ROSE>vidas restantes. <VI>Renaciendo en 3...",        
	LOST_ALL =      "<ROSE>¡Has perdido todas tus vidas!",        
	SD =            "<VP>¡Muerte súbita! A todos le quedan <N>1 <VP>vida restante",        
	WELCOME =       "<VP>¡Bienvenido a pewpew, <N>agáchate <VP>o presiona <N>la barra de espacio <VP>para disparar ítems!",        
	SOLE =          "<ROSE>¡${player} es el único superviviente!"
}

translations["fr"] = {        
	LIVES_LEFT =    "<ROSE>Il te reste <N>${lives} <ROSE>vies. <VI>Réapparition dans 3...",        
	LOST_ALL =      "<ROSE>Tu as perdu toutes tes vies !",        
	SD =            "<VP>Mort subite ! Il ne reste plus qu'<N>1 <VP>vie à tout le monde",        
	WELCOME =       "<VP>Bienvenue sur pewpew, <N>baisse toi <VP>ou utilise <N>la barre d'espace <VP>pour tirer des objets !",        
	SOLE =          "<ROSE>${player} est le seul survivant !"
}

translations["tr"] = {        
	LIVES_LEFT =    "<N>${lives} <ROSE> can?n?z kald?. <VI>3 saniye içinde yeniden do?acaks?n?z...",        
	LOST_ALL =      "<ROSE>Bütün can?n?z? kaybettiniz!",        
	SD =            "<VP>Ani ölüm! Art?k herkesin <N>1<VP> can? kald?",        
	WELCOME =       "<VP>pewpew odas?na ho?geldiniz, e?yalar f?rlatmak için <N>e?ilin <VP>ya da <N>spacebar <VP>'a bas?n!",        
	SOLE =          "<ROSE>Ya?ayan ki?i ${player}!"
}

local translate = function(term, lang, page, kwargs)
    local translation
    if translations[lang] then 
        translation = translations[lang][term] or translations.en[term] 
    else
        translation = translations.en[term]
    end
    translation = page and translation[page] or translation
    if not translation then return end
    return string.format(translation, kwargs)
end


--==[[ classes ]]==--

local Player = {}

Player.players = {}
Player.alive = {}
Player.playerCount = 0
Player.aliveCount = 0

Player.__index = Player
Player.__tostring = function(self)
    return table.tostring(self)
end

setmetatable(Player, {
    __call = function (cls, name)
        return cls.new(name)
    end,
})

function Player.new(name)
	local self = setmetatable({}, Player)
	
    self.name = name
	self.alive = false
	self.lives = 0
	self.inCooldown = true
	self.community = tfm.get.room.playerList[name].community
	self.hearts = {}

	self.rounds = 0
	self.survived = 0
	self.won = 0

	system.bindKeyboard(name, 32, true, true) -- space
	system.bindKeyboard(name, 0, true, true) -- left / a
	system.bindKeyboard(name, 2, true, true) -- right / d
	system.bindKeyboard(name, 3, true, true) -- down / s

	Player.players[name] = self
	Player.playerCount = Player.playerCount + 1

    return self
end

function Player:refresh()
	self.alive = true
	self.inCooldown = false
	self:setLives(3)
	Player.alive[self.name] = self
	Player.aliveCount = Player.aliveCount + 1
end

function Player:setLives(lives)
	self.lives = lives
	tfm.exec.setPlayerScore(self.name, lives)
	for _, id in next, self.hearts do tfm.exec.removeImage(id) end
	self.hearts = {}
	local heartCount = 0
	while heartCount < lives do
		heartCount = heartCount + 1
		self.hearts[heartCount] = tfm.exec.addImage(assets.heart, "$" .. self.name, -45 + heartCount * 15, -45)
	end
end

function Player:shoot(x, y)
	if newRoundStarted and self.alive and not self.inCooldown then
		
		self.inCooldown = true

		local stance = self.stance
		local pos = getPos(currentItem, stance)
		local rot = getRot(currentItem, stance)
		local xSpeed = currentItem == 34 and 60 or 40

		Timer("shootCooldown_" .. self.name, function(object)
			tfm.exec.removeObject(object)
			self.inCooldown = false
		end, 1500, false, tfm.exec.addShamanObject(
			currentItem,
			x + pos.x,
			y + pos.y,
			rot,
			stance == -1 and -xSpeed or xSpeed,
			0,
			currentItem == 32 or currentItem == 62
		))

	end	
end

function Player:savePlayerData()
	local name = self.name
    dHandler:set(name, "rounds", self.rounds)
    dHandler:set(name, "survived", self.survived)
	dHandler:set(name, "won", self.won)
	print(dHandler:dumpPlayer(name))
    system.savePlayerData(name, "v2" .. dHandler:dumpPlayer(name))
end


--==[[ events ]]==--

function eventNewPlayer(name)
    local player = Player.new(name)
    tfm.exec.chatMessage(translate("WELCOME", player.community), name)   
    Timer("banner_" .. name, function(image)
        tfm.exec.removeImage(image)
    end, 5000, false, tfm.exec.addImage(assets.banner, ":1", 120, -85, name))
    system.loadPlayerData(name)
end

function eventLoop(tc, tr)
	
	Timer.process()

	if tr < 0 and initialized then
		if not suddenDeath then			
			suddenDeath = true		
			tfm.exec.chatMessage(translate("SD", tfm.get.room.community))
			for name, player in next, Player.alive do
				player:setLives(1)
			end
			tfm.exec.setGameTime(30, true)
		else
			local aliveCount = Player.aliveCount
			if aliveCount > 1 then
				local winnerString = ""
				for name, player in next, Player.alive do
					player.rounds = player.rounds + 1
					player.survived = player.survived + 1
					if aliveCount == 1 then
						winnerString = winnerString:sub(1, -3) .. " and " .. name
						break
					end
					winnerString = winnerString .. name .. ", "
					aliveCount = aliveCount - 1			
				end
				tfm.exec.chatMessage("we have some loads of winners this time: " .. winnerString)
			end
			tfm.exec.chatMessage("starting a new round")
			Timer("newRound", newRound, 3 * 1000)
			tfm.exec.setGameTime(4, true)
		end
	end

end
function eventKeyboard(name, key, down, x, y)
	if key == 32 or key == 3 then -- space / duck
		Player.players[name]:shoot(x, y)
	elseif key == 0 then-- left
		Player.players[name].stance = -1
	elseif key == 2 then-- right
		Player.players[name].stance = 1
	end	
end

function eventNewGame()
	if initialized then
		Timer("pre", function()
			Timer("count3", function(count3)
				tfm.exec.removeImage(count3)
				Timer("count2", function(count2)
					tfm.exec.removeImage(count2)
					Timer("count1", function(count1)
						tfm.exec.removeImage(count1)
						newRoundStarted = true
						Timer("roundStart", function(imageGo)
							tfm.exec.removeImage(imageGo)
						end, 1000, false, tfm.exec.addImage(assets.newRound, ":1", 145, -120))
					end, 1000, false, tfm.exec.addImage(assets.count1, ":1", 145, -120))
				end, 1000, false, tfm.exec.addImage(assets.count2, ":1", 145, -120))
			end, 1000, false, tfm.exec.addImage(assets.count3, ":1", 145, -120))
		end, Player.playerCount == 1 and 0 or 4000)
	end
end
function eventPlayerDied(name)
	local player = Player.players[name]
	if not player then return end
	if not newRoundStarted then
		tfm.exec.respawnPlayer(name)
		return player:refresh()
	end
	player.lives = player.lives - 1
	tfm.exec.setPlayerScore(name, player.lives)
	player.alive = false

	if player.lives == 0 then
		
		Player.alive[name] = nil
		tfm.exec.chatMessage(translate("LOST_ALL", player.community), name)
		player.rounds = player.rounds + 1
		Player.aliveCount = Player.aliveCount - 1
		
		if Player.aliveCount == 1 then
			local winner = next(Player.alive)
			local winnerPlayer = Player.players[winner]
			tfm.exec.chatMessage(translate("SOLE", tfm.get.room.community, nil, {player = winner}))
			tfm.exec.giveCheese(winner)
			tfm.exec.playerVictory(winner)
			winnerPlayer.rounds = winnerPlayer.rounds + 1
			winnerPlayer.survived = winnerPlayer.survived + 1
			winnerPlayer.won = winnerPlayer.won + 1				
			Timer("newRound", newRound, 3 * 1000)
		elseif Player.aliveCount == 0  then
			Timer("newRound", newRound, 3 * 1000)
		end
		
	else

		tfm.exec.chatMessage(translate("LIVES_LEFT", player.community, nil, {lives = player.lives}), name)
		Timer("respawn_" .. name, function()
			tfm.exec.respawnPlayer(name)
			player:setLives(player.lives)
			player.alive = true
		end, 3000, false)

	end
end

function eventPlayerLeft(name)
	if Player.players[name] then
		Player.players[name].lives = 1
		eventPlayerDied(name)
		Player.players[name] = nil
		Player.playerCount = Player.playerCount - 1
	end
end
function eventPlayerDataLoaded(name, data)
	-- reset player data if they are stored according to the old version
	if data:find("^v2") then
        dHandler:newPlayer(name, data:sub(3))
    else
        system.savePlayerData(name, "")
        dHandler:newPlayer(name, "")
    end

	Player.players[name].rounds = dHandler:get(name, "rounds")
	Player.players[name].survived = dHandler:get(name, "survived")
	Player.players[name].won = dHandler:get(name, "won")

	print(table.tostring(Player.players[name]))
	print(dHandler:dumpPlayer(name))

end

--==[[ main ]]==--

local rotation, currentMapIndex = {}

local shuffleMaps = function(maps)
    local res = {}
    for _, map in next, maps do
        res[#res + 1] = map
        res[#res + 1] = map
    end
    table.sort(res, function(e1, e2)
        return math.random() <= 0.5
    end)
    return res
end

newRound = function()
    
    newRoundStarted = false
    suddenDeath = false
    currentMapIndex = next(rotation, currentMapIndex)
    
    tfm.exec.newGame(rotation[currentMapIndex])
    tfm.exec.setGameTime(93, true)
    
    Player.alive = {}
    Player.aliveCount = 0

    for name, player in next, Player.players do
        player:savePlayerData()
        player:refresh()
    end
    
    if currentMapIndex >= #rotation then
        rotation = shuffleMaps(maps)
        currentMapIndex = 1
    end

    if not initialized then
        initialized = true
        closeSequence[1].images = { tfm.exec.addImage(assets.items[currentItem],":1", 630, 210) }
        Timer("changeItem", function()
            if math.random(1, 3) == 3 then
                currentItem = 17 -- cannon
            else
                currentItem = items[math.random(1, #items)]
            end
            tfm.exec.removeImage(closeSequence[1].images[1])
            closeSequence[1].images = { tfm.exec.addImage(assets.items[currentItem], ":1", 630, 210) }    
        end, 10000, true)
    end

end

getPos = function(item, stance)
	if item == 17 then		
		return { x = stance == -1 and 10 or -10, y = 18 }	
	elseif item == 24 then		
		return { x = 0, y = 10 }	
	else		
		return { x = stance == -1 and -10 or 10, y = 0 }	
	end
end

getRot = function(item, stance)	
	if item == 32 or item == 35 or item == 62 then
		return stance == -1 and 180 or 0	
	elseif item == 17 then
		return stance == -1 and -90 or 90
	else
		return 0	
	end
end

do
    rotation = shuffleMaps(maps)
    currentMapIndex = 1
    Timer("newRound", newRound, 6 * 1000)
    tfm.exec.newGame(rotation[currentMapIndex])
    tfm.exec.setGameTime(8)
    for name in next, tfm.get.room.playerList do
        eventNewPlayer(name)
    end
end



