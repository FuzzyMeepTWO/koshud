global boottime to time:seconds.
global debug to 0. // shows input and output for triggered item. use for checking which modules are called for failed trigger. logging is better.
global dbglog to 0. // 0 = OFF 1 = LOG  2= Detailed Log 3 = advanced LOG WITH METER/FUEL CHECK AND STARTUP SPAM (you probably dont want 3)
//#region NOTES
// things to fix
  //check how it handles docking
  //check if 2 vehicles same docking
  //sounds

//items to update 

//STRETCH GOALS
  //make continue work on liist auto
  //check name saved for payloadpart
  //add to orbit to autopiilot
  //add copy to other core
  //make PAL work
  //hover option. (when i need it)
  //reaction wheel wheel authority
  //CAP DISCHARGE RATE
  //add option to change monitor in flight
  //thermal warning
  

//probably wont work or wont bother with
  //add biome to auto state //Need to figure out if i cant get a list of all biomes on current SOI or wont work.
  // fix reaction wheels // has 2 fields with the same name makes errors
    //get meter for antenna based on range to target and ant range. maybe
//#endregion
 //#region set start vars
global loadattempts to 0.
local cnt to 0.
LIST PROCESSORS IN coreList.
for i in corelist {if i:TAG = "" set i:TAG to "C"+cnt. set cnt to cnt+1.}
global proot is "0:/". //path():root. 
global SubDirSV IS proot+"ShipAutoSV/".                   //directory for auto option save
global Autofile is ship:name+"-"+core:tag+".json".        //filename for auto option save
global AutofileBAK is ship:name+"-"+core:tag+".bak.json". //filename for BKP option save
global DebugLog to "0:/KosHud.log".                       //filename for log file.
local fileList is list().
local found is false.
list files in fileList.
for file in fileList {if file = DebugLog set found to true.}
IF found = true  DELETEPATH(DebugLog).

 if DbgLog > 0 {
    log2file("################################################################################").
    log2file("|                              KERBAL HUD SYSTEM                               |").
    log2file("|                              BY  FUZZYMEEP TWO                               |").
    log2file("|                                VERSION 1.01                                  |").
    log2file("|___________________________________LOADING____________________________________|").
    log2file("################################################################################").
 }
global colorprint to 1. // fancy colors?
Global ForceMon to 0. // set to force specific monitorif over 0, will use forcemon-1 for trg mon
SET FASTBOOT TO 0. // REMOVES PAUSES FROM LOAD ITEMS LIST 
SET QUICKREBOOT TO 1. //SKIPS ITEM DETECT ON match //2 loads all from file on fingerprint match
IF NOT (DEFINED PRTCount){global PRTCount to SHIP:PARTS:LENGTH.}else{if prtcount <> SHIP:PARTS:LENGTH{Set quickreboot to 0. set PRTCount to SHIP:PARTS:LENGTH.}} 
global FuelUpdRate to "Fast".
global ClrMin to 0.
if colorprint > 0 set ClrMin to 9.
global acp to 7.
GLOBAL LOADBKP TO 0.
global printpause to 0.
GLOBAL SAVEBKP TO 0.
global twr to 0.
global LFX to 0.
global saveflag to 0.
global widthlim to 80.
global dctnmode to 0.
GLOBAL STPREV TO "".
GLOBAL BOTPREV TO "".
global setdelay to 0.
global Curdelay to 0.
global HDItm to 1.
global HDTag to 1.
global HDItmB to 1.
global HDTagB to 1.
global apsel to 1.
global h5mode to 0.
GLOBAL DCPRes TO 0.
GLOBAL MISSINGPART TO 0.
global AutoSetAct to 1.
global AutoSetMode to 1.
global AutoRstMode to 1.
global refreshRateSlow to 5.
global refreshRateFast to 1.
GLOBAL VLIMSTRT TO 500.
global PLIMSTRT to 60.
global LLIMSTRT to 40.
GLOBAL HLIMSTRT TO 5000.
GLOBAL VLIM TO VLIMSTRT.
GLOBAL PLIM TO PLIMSTRT.
GLOBAL LLIM TO LLIMSTRT.
GLOBAL HLIM TO HLIMSTRT.
global plimadj to 0.
global ln14 to 0.
global flyadj to list(0,0,0,0,0,0,0).
global ALTPRV to ship:altitude.
GLOBAL VSPDPRV TO SHIP:verticalspeed.
GLOBAL SPDPRV TO SHIP:VELOCITY:SURFACE:MAG.
global RFSBAak to refreshRateSlow.
global lostparts to list().
GLOBAL PRINTQ IS QUEUE().
GLOBAL THRTFIX TO 0.
GLOBAL THRTPREV TO THROTTLE.
GLOBAL AUTOBRAKE TO 2. //2 IS BRAKES ON UNDER 50% THROTTLE AND LANDED, 0 IS OFF, 1 IS ON.
GLOBAL AUTOLOCK TO 2. //AUTO LOCK MOVABLE PARTS AFTER MOVE 0 = off up to 5 seconds
global IsPayload to list(0,core:part).
set IsPayload to checkdcp(core:part,"payload").
//VARS NEEDED FOR CALLS.
GLOBAL ID TO "".
set bigempty2 to"                                                                              ".
set bigempty to"                                                                           ".
SET LNstp TO 1.
GLOBAL V0 to GetVoice(0).
global rowT1 to "".
global rowT2 to "".
global senselist to list(0,0,0,0,0,0).
global rowval to 0.
global rtech to 0.
global mks to 0.
global zop to 1.
global forcerefresh to 0.
global RunAuto to 1.
global MonAutoCyc to 1.
global BtnActn to 0.
global airmax to 0.
global monitorIndex to -1.
    global HudOpts to list(0).
    global ItemListHUD to list().
    global ItemList to list(0).
      global prtTagList to list(List(0)).
          set prtList to list(List(List(0))).
            global GrpOpsList to list(List(List(0))).
            set GrpDspList to list(List(List(0))).
            global GrpDspList2 to list(List(List(0))).
            global GrpDspList3 to list(List(List(0))).
            global AutoDspList to list(List(List(0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))).
            global autoRstList to list(List(List(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))).
            global AutoValList to list(List(List(0))).
            global AutoRscList to list(List(List(0))).
            global AutoTRGList to list(List(List(0))).
            set modulelist to list(ItemList[0]). 
            set modulelistAlt to list(ItemList[0]).
            set modulelistRPT to list(ItemList[0]).
GLOBAL HEIGHT TO 0.
global botrow to bigempty2.
global paidmeter to 0.
global aplim to 1.
GLOBAL ActionQNew to list().
global HdngSet to list(list(9,0  ,0   ,0   ,0   ,0      ,0   ,60 ,40  ,60 ), //set
                       list(9,359, 180, 180,5000,1000000, 500,180,5000,180), //max
                       list(9,0  ,-180,-180,0   ,0      ,-500,0  ,0   ,0  ), //min
                       list(9,1  ,1   ,1   ,0   ,0      ,0   ,1  ,0   ,0  )). //on/off
                       if ship:type = "plane" set aplim to 3.
//(SET,MAX,MIN,TOGGLE)
//(COUNT,HEADING, PITCH, ROLL, SPD, ALT, VLIM, PITCHLIM(ABS), MINSPD(ABS), AOALIM(abs). )
GLOBAL MONITORID TO 0.
global mtrcur to list(0,100,5,1,1,1). //mtrvalmin,mtrvalmax,mtrvaladj,mtroptnmin,mtroptnmax,mtroptn
GLOBAL TUNECLAMP TO 1.
global StrLock to 0.
global cmlist to list().
global TrgLim to 1.
global  FindCl to lexicon("GREEN","").
        FindCl:add("RED","[#FF0000]").
        FindCl:add("CYN","[#00FFFF]").
        FindCl:add("YLW","[#FFFF00]").
        FindCl:add("WHT","[#FFFFFF]"). 
        FindCl:add("BLU","[#0000FF]").
        FindCl:add("BLK","[#000000]").  
        FindCl:add("PRP","[#FF00FF]").
        FindCl:add("ORN","[#ffae00]").
        FindCl:add("YRN","[#ffb300]").
        FindCl:add("RRN","[#ff6200]").
        FindCl:add("YGR","[#c8ff00]").
        FindCl:add("GRN","[#00ff00]").
global  FindCl2 to lexicon("  DELETE  ","ORN"," TRANSMIT ","WHT", " SET TRGT ", "WHT"," DPST RSC ","WHT","SPRNG AUTO","GRN","SPRNG MAN ","GRN", " RUN TEST ","WHT","  EXTEND  ","CYN","  DEPLOY  ","CYN","  RETRACT ","RED"," LIGHT OFF","ORN"," LIGHT ON ","WHT"," MODE OFF ","YLW"," MODE ON  ","PRP","   FIRE   ","ORN"). 
global actnlist to list(1,"","","","").
Global biomecur to "UNKNOWN".
global trimwords to list("Experiment","Sina","-MLEM","-MGS","-MGC","#LOC_AA_","_title","title", "DISPENSER").
//global trimwords2 to list("idle","percent").
global MODESHRT TO lIST(15, " OFF", " SPD"," ALT"," AGL"," EC "," RSC ","THRT","PRES", " SUN","TEMP","GRAV"," ACC"," TWR","STAT","FUEL"). 
GLOBAL MODELONG TO LIST(15,"    OFF   ","   SPEED  "," ALTITUDE "," ALT AGL  ","ELEC. CHRG"," RESOURCE "," THROTTLE "," PRESSURE ","   SUN    ","   TEMP   ","  GRAVITY ","  ACCEL.  ","   TWR    ","  STATUS  ","   FUEL   ").
GLOBAL STATUSOPTS TO LIST(12,"LANDED","SPLASHED","PRELAUNCH","FLYING","SUB_ORBITAL","ORBITING","ESCAPING","DOCKED","APOAPSIS","PERIAPSIS","NEXT NODE","TRANSITION").
GLOBAL STATUSSAVE TO LIST("LANDED","SPLASHED","PRELAUNCH","ORBITING").
GLOBAL STATUSSPACE TO LIST("SUB_ORBITAL","ORBITING","ESCAPING").
GLOBAL STATUSLAND TO LIST("LANDED","SPLASHED","PRELAUNCH","FLYING").
GLOBAL STATUSFLY TO LIST("FLYING","SUB_ORBITAL").
GLOBAL StsSelection TO 1.
global buttons to addons:kpm:buttons.
global AutoMinMax to list(0,list(0,0)).
for i in range (2,modelong[0]+1){AutoMinMax:add(list(0,list(0,0),list(0,0))).}
//CHECK ADDONS
//global agx to 0.
//if ADDONS:AVAILABLE("AGX") set AGX to Addons:AGX.
if addons:available("RT") set RTech to addons:RT.
//#endregion
//#region set lists
global  autotaglist to list("ModuleScienceExperiment","ModuleProceduralFairing","DischargeCapacitor","ModuleScienceLab","BDModulePilotAI","MissileFire","ModuleScienceLab","usi_converter","usi_harvester","DMModuleScienceAnimateGeneric","ModuleAnimationGroup", "WOLF_SurveyModule","SCANexperiment","ModuleOrbitalSurveyor").
set AnimModAlt to list("ModuleAnimateGeneric","ModuleAnimationGroup","DMModuleScienceAnimateGeneric","USIAnimation","scansat").
set lightMod to list("Lights"     , "  LIGHTS  ","ModuleLight","ModuleNavLight", "ModuleColorChanger","ModuleAnimateGeneric").
set lightModAlt to lightMod:sublist(2,lightMod:length).
//set lightmodskp to list("RetractableLadder","ModuleWheelBase","ModuleWheelDeployment","ModuleDockingNode"). //ADD MODULES WITH BUILTIN LIGHTS TO SKIP ADD TO LIGHT
set lightmodskp to list("RetractableLadder","ModuleDockingNode"). //ADD MODULES WITH BUILTIN LIGHTS TO SKIP ADD TO LIGHT
set AGMod to list("Action Group"  ," ACTN GRP ","").
set FlyMod to list("Flight Control","FLGHT CTRL","").
set CntrlMod to list("control srf", "CNTRL SURF","ModuleControlSurface","SyncModuleControlSurface", "ModuleAeroSurface").
set CntrlModAlt to CntrlMod:sublist(2,CntrlMod:length).
set engMod to list("Engines"      , " ENGINES  ","MultiModeEngines","ModuleEnginesFX","ModuleEngines").// (name, name for hud, module1, module2)
set engModAlt to engMod:sublist(2,engMod:length).
set dcpMod to list("Decoupler"    , "DECOUPLERS","ModuleDecouple","ModuleAnchoredDecoupler","ModuleAnchoredDecouplerBdb").
set DcpModAlt to dcpMod:sublist(2,dcpMod:length).
set gearMod to list("Gear"        , "   GEAR   ","ModuleWheelDeployment", "ModuleAnimateGeneric").
set chuteMod to list("Parachute"  , "PARACHUTES","ModuleParachute","RealChuteModule").
set chuteModAlt to chuteMod:sublist(2,chuteMod:length-1).//REMOVE -1 AFTER TESTING REALCHUTE
set ladMod to list("Ladder"       , "  LADDER  ","RetractableLadder").
set bayMod to list("Cargo Bay"    , "CARGO BAYS","ModuleCargoBay", "Hangar").
set DockMod to list("Docking Port", "  DOCKING ","ModuleDockingNode","ModuleGrappleNode").
set DockModAlt to DockMod:sublist(2,DockMod:length).
set RWMod to list("Reaction Wheel", " RCTNWHEEL","ModuleReactionWheel").
set slrMod to list("Solar Panel"  , "SOLAR PNLS","ModuleDeployableSolarPanel","KopernicusSolarPanel","ModuleResourceConverter").
set slrModAlt to slrMod:sublist(2,slrMod:length-1).
set RCSMod to list("RCS"          , "   RCS    ", "ModuleRCSFX").
set drillMod to list("Drill"      , "  DRILLS  ","ModuleResourceHarvester").
set radMod to list("Radiator"     , " RADIATORS","ModuleActiveRadiator","ModuleDeployableRadiator").
set scimod to list("Experiment"   , "XPERIMENTS","ModuleScienceExperiment","ModuleResourceScanner","DMModuleScienceAnimateGeneric", "WOLF_SurveyModule","SCANexperiment","SCANsat","ModuleOrbitalSurveyor").
set SciRun to list("run","log","irradiate", "perform", "start", "measure","report"," observ","scan","take").
set sciModAlt to list("ModuleScienceExperiment","DMModuleScienceAnimateGeneric","ModuleAnimationGroup", "WOLF_SurveyModule","SCANexperiment","ModuleOrbitalSurveyor","SCANsat").
set sciModData to list("ModuleScienceExperiment","DMModuleScienceAnimateGeneric","SCANexperiment","ModuleOrbitalSurveyor", "scansat").
set antMod to list("Antenna"      , " ANTENNAS ","ModuleDeployableAntenna","modulertantenna", "ModuleRTAntennaPassive","ModuleDataTransmitter","ModuleAnimateGeneric").
set AntModAlt to list("ModuleDeployableAntenna","modulertantenna", "ModuleRTAntennaPassive","ModuleDataTransmitter","ModuleAnimateGeneric").
set FWMod to list("Firework"      , " FIREWRKS ","ModulePartFirework").
set ISRUMod to list("Converter"   , "   ISRU   ","ModuleResourceConverter").
set LabMod to list("Science Lab"  , " SCI-LAB  ","ModuleScienceLab").
set RBTMod to list("Robotics"     , " ROBOTICS ","ModuleRoboticServoPiston","ModuleRoboticServoRotor","ModuleRoboticServoHinge","ModuleRoboticRotationServo","ModuleRoboticController").
//MKS MOD
set MksDrlMod to list("MKS Harvest"," MKS HRVST","usi_harvester").
set MksDrlModAlt to MksDrlMod:sublist(2,MksDrlMod:length).
set PWRMod to list("MKS Resources", " MKS RSC  ","usi_converter").
set PWRModALT to PWRMod:sublist(2,PWRMod:length).
set DEPOMod to list("MKS Depot"   , " MKS DPOT ","Wolf_Depotmodule").
set habMod to list("MKS Deployable", " MKS DPLY ","USIAnimation","USI_BasicDeployableModule").
set CnstMod to list("MKS Constructor"    , " CONSTRCT ","OrbitalKonstructorModule", "ModuleKonFabricator").
set DcnstMod to list("MKS Deconstructor", " DCNSTRCT ","ModuleDekonstructor").
set ACDMod to list("MKS Academy"  , " MKS ACDMY","spaceacademy").
//OTHER MODS
set CapMod to list("Capacitor"    , "CAPACITOR ","DischargeCapacitor").
set BDPMod to list("BD Pilot", " BD PILOT ","BDModulePilotAI").
set CMMod to list("Countermeasure", "CNTRMSURES","CMDropper").
set RadarMod to list("Radar"      , "  RADAR   ","ModuleRadar").
set FRNGMod to list("Fairing"     , "  FAIRING ","ModuleProceduralFairing").
set WMGRMod to list("Weapon Manager", " WEAPONS  ","MissileFire").
global DcpXtraMod to list().
for itm in list(engModAlt,chuteModAlt,cntrlModAlt){
  for itm2 in itm{DcpXtraMod:add(itm2).}
}
//#endregion
//#region Check BootLoop and Monitor
IF CORE:MESSAGES:EMPTY{}ELSE{
  SET RECEIVED TO CORE:MESSAGES:POP.
    if RECEIVED:content < 0 {set loadattempts to 0.}
    else{SET loadattempts TO 1+RECEIVED:CONTENT.}
}
SendBoot().
IF  SHIP:status = "LANDED" or SHIP:status = "PRELAUNCH"{
  SET BRAKES TO TRUE. // brakes and check height on launch.
  IF ALT:RADAR > 0 {SET HEIGHT TO HEIGHT-(0-(ALT:RADAR)).}
  ELSE{IF ALT:RADAR < 0 {SET HEIGHT TO HEIGHT+(0-(ALT:RADAR)).}}
}
if height > 1000 set height to 0.
if not (defined monitorGUID) global monitorGUID to 0.
desktop().
print "LOAD ATTEMPTS:"+loadattempts+"        ("+(3-loadattempts)+" MORE TO TRIGGER BOOTLOOP FIX)" at (1,18). wait loadattempts.
if dbglog > 0 log2file("LOAD ATTEMPTS:"+loadattempts+"        ("+(3-loadattempts)+" MORE TO TRIGGER BOOTLOOP FIX)").
IF loadattempts > 2 BootLoopFix().
IF file_exists(autofile){global LISTIN TO READJSON(SubDirSV + autofile).
    IF not (DEFINED monitorselected){
       IF DEFINED listin{
        set MONITORID to listin[8].
        if monitorid > 0 {IF MONITORID:substring(0,7) = "0000000" SET FORCEMON TO MONITORID:substring(7,1):TONUMBER+1.ELSE SET monitorGUID TO listin[8].}
      }
        local totalMonitors to addons:kpm:getmonitorcount() - 1.
          for index in range(0, totalMonitors){
             if forcemon > 0 {
            if index = forcemon-1 {
              set monitorGUID to addons:kpm:getguidshort(index). 
              set buttons:currentmonitor to index.
              set id to addons:kpm:getguidshort(index).
              global monitorselected to 1. 
              PRINT "MONITOR FORCED TO MON "+index at (1,18).WAIT 1.
              if dbglog > 0 log2file("MONITOR FORCED TO MON "+index).
               break. 
            }}
            if addons:kpm:getguidshort(index) = monitorGUID {
              set buttons:currentmonitor to index.
              set id to addons:kpm:getguidshort(index).
              global monitorselected to 1.
              PRINT "MONITOR LOADED FROM MEMORY" at (1,18). set fastboot to 1. WAIT 1.
              if dbglog > 0 log2file("MONITOR LOADED FROM MEMORY").											  
            }
          }
    }
  }
IF not (DEFINED monitorselected) {setmonvis().}else{IF monitorselected = 0 setmonvis().}
IF NOT (DEFINED setupdone){loadship().}ELSE{
  IF QUICKREBOOT > 0 {IF file_exists(autofile){loadAutoSettings().}}ELSE {loadship().}}
HudFuction().
    if loadbkp = 2 { set LNstp to 1. set line to 1. DESKTOP(). loadship(). HudFuction().}
//#endregion
//#region Ship Setup
function desktop{
  clearScreen.
  for i in range (0,18){
                     local po to "|                                                                              |".
    if i = 0 or i = 17 set po to "################################################################################".
    if i = 8           set po to "|                              KERBAL HUD SYSTEM                               |".
    if i = 9           set po to "|                              BY  FUZZYMEEP TWO                               |".
    if i = 10          set po to "|                                VERSION 1.01                                  |".
    if i = 15          set po to "|___________________________________LOADING____________________________________|".
    print po at (0,i).
}}
Function LoadShip{
   if DbgLog > 0 log2file("LOADSHIP" ).
  local parameter runop is 1.
      set loading to 0.
    set loadperstep to 1.
    set listinc to 0.
    local rc to 0.
    local la to 2-runop.
  if runop = 1 {DESKTOP(). firststrun().} else set listinc to 0.
  Function firststrun{
    if DbgLog > 0 log2file("FIRSTRUN" ).
  //#region set lists and tags
    global PrtListIn to SetPartList(ship:parts).
    loadbar().
    AutoTag(). //get science part names
      local prtlstintmp to list().
      for prt in PrtListIn{if prt:tag <> "" prtlstintmp:add(prt).}
      set PrtListIn to prtlstintmp:copy.
    set lighttag to makelists(lightMod,"lighttag").
    set AGTag to  makelists(AGMod,"AGTag").
    set FlyTag to makelists(FlyMod,"FlyTag").
    set CntrlTag to makelists(CntrlMod,"CntrlTag").
    set engtag to makelists(engMod,"engtag").
    set dcptag to makelists(dcpMod,"dcptag").
    set geartag to makelists(gearMod,"geartag").
    set chutetag to makelists(chuteMod,"chutetag").
    set ladtag to makelists(ladMod,"ladtag").
    set baytag to makelists(bayMod,"baytag").
    set Docktag to makelists(DockMod,"Docktag").
    set RWtag to makelists(RWMod,"RWtag").
    set slrtag to makelists(slrMod,"slrtag").
    set RCStag to makelists(RCSMod,"RCStag").
    set drilltag to makelists(drillMod,"drilltag").
    set radtag to makelists(radMod,"radtag").
    set scitag to makelists(scimod,"scitag").
    set anttag to makelists(antMod,"anttag").
    set FWtag to makelists(FWMod,"FWtag").
    set ISRUTag to makelists(ISRUMod,"ISRUTag").
    set Labtag to makelists(LabMod,"Labtag").
    set RBTTag to makelists(RBTMod,"RBTTag").
    //MKS MOD
    set MksDrlTag to makelists(MksDrlMod,"MksDrlTag").
    set PWRTag to makelists(PWRMod,"PWRTag").
    set DEPOTag to makelists(DEPOMod,"DEPOTag").
    set habTag to makelists(habMod,"habTag").
    set CnstTag to makelists(CnstMod,"CnstTag").
    set DcnstTag to makelists(DcnstMod,"DcnstTag").
    set ACDTag to makelists(ACDMod,"ACDTag").
    //OTHER MODS
    set CapTag to makelists(CapMod,"CapTag").
    //BDA MOD (KEEP LAST TO MAAKE WMGR QUICKLY ACCESSABLE)
  // set Missiletag to makelists(MissileMod,"set").
  // set Guntag to makelists(GunMod,"set").
    set BDPtag to makelists(BDPMod,"BDPtag").
    set CMtag to makelists(CMMod,"CMtag").
    set Radartag to makelists(RadarMod,"Radartag").
    set FRNGtag to makelists(FRNGMod,"FRNGtag").
    set WMGRtag to makelists(WMGRMod,"WMGRtag").
    set itemlist[0] to listinc.
    ItemListHUD:INSERT(0,listinc).
  }
   local pc to 3.
   loadbar().
    IF (DEFINED listin){IF LOADBKP <> 2 {printrow(GetColor("Loading Auto Settings.","CYN",0)). loadAutoSettings(la).set LNstp to LNstp-1.}} loadbar().
    IF LOADBKP = 2 {set pc to 2. set rc to 1. printrow(GetColor("Loading Backup Settings.","ORN",0)). loadAutoSettings(la). set LNstp to LNstp-1.} loadbar(). 
    if GrpdspList:length < itemlist[0]+1 or runop = 0 or rc = 1 or LFX > 0{
        printrow(GetColor("Adjusting for Loaded Settings.","WHT",0)). dsplistfix().  loadbar().
    }
    if runop <> 0{
      //set GrpdspList[flytag][1] to 1.
      if AutoDspList[0]:length = 1 addlist().
      printrow(GetColor("Checking Part Availability.","YLW",0)).partcheck(pc). loadbar().
      if dcptag <> 0{printrow(GetColor("Checking Decoupler Parts.","ylw",0)). DcpGauges(prtTagList[dcptag]).} loadbar().
      printrow(GetColor("Setting Auto Triggers.","WHT",0)).SetAutoTriggers(2). loadbar(). 
      printrow(GetColor("Saving Auto Settings.","PRP",0)). SaveAutoSettings(0). loadbar(). 
      printrow(GetColor("Setting Module Commands.","WHT",0)). SetModules().    loadbar(). 
      printrow(GetColor("Checking Ship Resources.","YLW",0)). ISRUcheck().     loadbar(). 
      printrow(GetColor("Checking Module States.","YLW",0)).  CheckSettings(). loadbar(). 
      printrow(GetColor("Checking Sensor Availability.","YLW",0)). checkmodeavail(). loadbar().
    FOR i IN RANGE(1, 79) {
      print "#" at (i,16).
    IF FASTBOOT = 0 wait.01.
    }
      if AutoDspList[0]:length = 1 addlist().
      global setupdone to 1.
  }
  
  //#endregion setup done
    function makelists{
      local parameter ModulesIn, tagnameIn.
      local typename to modulesin[0].
      local HUDname to modulesin[1].
      local modules to modulesin:sublist(2,modulesin:length).
      local hasmod to 0.
      if typename <> "Action Group" and  typename <> "Flight Control"{
        for m in modules{
          set hasmod to SHIP:MODULESNAMED(m).
          if hasmod:length > 0 break.
        }
      IF hasmod = 0 {if listinc > 1 loadbar(). return 0.}
      if DbgLog > 0 log2file("MAKE LIST "+tagnameIn+"-"+LISTTOSTRING(modulesin)).
      global tempTAGS TO TAGCHECK(typename,modules).
      }else{
        if typename = "Action Group"set tempTAGS to list(12,"AG1","AG2","AG3","AG4","AG5","AG6","AG7","AG8","AG9","AG10", "THROTTLE","RCS").
        if typename = "Flight Control"set tempTAGS to list(12,"HEADING","PROGRADE", "RETROGRADE", "NORMAL", "ANTI NORMAL", "RADIAL OUT", "RADIAL IN", "TARGET", "ANTI TARGET", "MANEUVER", "STABILITY ASSIST", "STABILITY").
      }
      if tempTAGS[0] = 0{if listinc > 1 loadbar(). return 0.}
        else{
          set listinc to listinc+1. 
          ItemList:add(typename).
          prtlist:add(list(list(tagnameIn+"/"+listinc))).
          GrpOpsList:add(list(0)).
          ItemListHUD:add(HUDname).
          prtTagList:add(list(tempTAGS[0])).
          set prttaglistR to "".
        }
        if listinc > 1 loadbar(). 
        if tempTAGS[0] <> 0{
          FOR i IN RANGE(1, tempTAGS[0]+1) {
            set prttaglistR to prttaglistR+tempTAGS[I]+",".
            prtTagList[listinc]:add(tempTAGS[I]).
            local prt to list().
            for m in modules{
              if SHIP:MODULESNAMED(m):length > 0 {
                //if dbglog > 2 log2file("         "+"    MODULE:"+m).
                for p in SHIP:PARTSDUBBED(tempTAGS[I]){
                  if p:hasmodule(m){
                    //if dbglog > 2 log2file("         "+p).
                    if typename = "Lights" {
                      
                      if m="ModuleColorChanger" or m="ModuleAnimateGeneric"{if not p:getmodule(m):hasaction("toggle lights") set p to "".}
                      if p:typename <> "string" for md in lightmodskp{ if p:hasmodule(md) {set p to "". break.}}
                    }
                    if p <>"" and not prt:contains(p)prt:add(p).
                  }
                }
              }
            }
            if typename = "Action Group" prt:add(core:part). 
            if typename = "Flight Control" prt:add(core:part). 
            prt:insert(0, prt:length). 
            prtList[listinc]:add(prt).
          } 
          LOCAL TG TO " Tags".
          IF tempTAGS[0] = 1 SET TG TO " Tag".
         if typename ="Experiment" {printrow(tempTAGS[0]+":"+typename +TG+" Found").}else{
         if typename ="Action Group" {printrow(tempTAGS[0]+":"+typename +TG+" Found").}else{
        if typename ="Flight Control" {printrow(tempTAGS[0]+":"+typename +TG+" Found").}
         else{printrow(tempTAGS[0]+":"+typename +TG+" Found:"+prttaglistR).}}}

        }
        loadbar(). 
        if tempTAGS[0] <> 0{
          dsplists(tempTAGS[0]+1,typename,listinc,1).
          if typename = "Lights" { print "|       Tagged Lights Found. Lights Will Turn on With Matching Tags" at (0,LNstp).SET LNstp TO LNstp+1.}
        }
        loadbar().
        FUNCTION TAGCHECK{
          local PARAMETER tname, ml.
          if DbgLog > 1 log2file("   TAGCHECK:"+TNAME ).
          local tl to list(). 
          for m in ml{
            LOCAL ModFound TO 0.
            LOCAL MDLGD TO 0.
            LOCAL TGLGD TO 0..
              for p in PrtListIn {
                if p:hasmodule(m) {
                  //SET ModFound TO 1.
                  local t to p:Tag. 
                  if not tl:contains(p:tag) {
                    SET TGLGD TO 0.
                    if tname = "Converter" {
                      if p:name:contains("fuelcell") set t to "".}
                    else{
                    if tname = "Solar Panel" {
                      if p:name:contains("ISRU") set t to "".
                      set ModFound to 1.
                      }
                    else{
                    if tname = "Cargo Bay" {
                      if p:hasmodule("ModuleProceduralFairing") set t to "".}
                    else{
                    if tname = "Lights"{
                      if p:hasmodule("ModuleColorChanger") {if not p:getmodule("ModuleColorChanger"):hasaction("toggle lights") set t to "".}
                        else{
                          if p:hasmodule("ModuleAnimateGeneric") {if not p:getmodule("ModuleAnimateGeneric"):hasaction("toggle lights") set t to "".}
                        }
                          for md in lightmodskp if p:hasmodule(md) {set t to "". break.}
                      }
                    else{
                    if tname = "Antenna" {
                      if p:hasmodule("ModuleRTAntenna"){if p:getmodule("ModuleRTAntenna"):hasfield("omni range") or rtech = 0 {set t to "".}}
                      if p:hasmodule("ModuleAnimateGeneric"){local aa to p:getmodule("ModuleAnimateGeneric"):allactions. for a in aa{if not a:contains("anten") and not p:hasmodule("ModuleRTAntenna") set t to "".}}}
                    else{
                    if tname = "Gear"{
                      if p:hasmodule("ModuleAnimateGeneric"){
                        if not p:hasmodule("ModuleWheelDeployment"){
                          if not p:getmodule("ModuleAnimateGeneric"):hasaction("toggle leg"){set t to "".}}}}
                    else{
                    if tname = "RCS" {
                      if p:hasmodule("ModuleRCSFX"){
                        if p:getmodule("ModuleRCSFX"):hasevent("show actuation toggles"){p:getmodule("ModuleRCSFX"):doevent("show actuation toggles").}}}
                    else{}}}}}}}
                    if t <>"" tl:add(t).
                  }
                  if MDLGD = 0 and dbglog > 2 {log2file("       MOD:"+M ). SET MDLGD TO 1.}
                  if dbglog > 2 AND t <>"" {
                    IF TGLGD = 0 {log2file("           TAG:"+t). SET TOUT TO T.}
                    IF P:TAG = TOUT log2file("               "+P ).
                    SET TGLGD TO 1.
                  }
                }
              }
              if ModFound = 1 break.
              }
          tl:insert(0, tl:length). 
          if TL:empty{SET TL TO LIST(0).}
          return tl.
        }
        if tempTAGS[0] = 0{return 0.}else{return listinc.}
    }
    function dsplistfix{
      if DbgLog > 0 log2file("dsplistfix" ).
            set  GrpOpsList to list(List(List(0))).
            set  GrpDspList to list(List(List(0))).
            set  GrpDspList2 to list(List(List(0))).
            set  GrpDspList3 to list(List(List(0))).
            set ItemListHUD to list().
            local loadp to 28. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
        for I in Range(1,ItemList[0]+1){
          GrpOpsList:add(list(0)).
          set loadp to loadp+1. print "." at (loadp,LNstp-1).
          dsplists(prtTagList[I][0]+1, prtList[I][0][0]:split("/")[1]:tonumber,i,2).
        }
        ItemListHUD:insert(0,ItemListHUD:length).
    }
    function dsplists{ 
          local parameter Tgin, typename, lnc, opin.
            if opin = 2{
              local HUDname to "          ".
              if typename = lighttag {set typename to "Lights". set HUDname to  "  LIGHTS  ".}
              if typename = AGtag {set typename to "Action Group". set HUDname to " ACTN GRP ".}
              if typename = Flytag {set typename to "Flight Control". set HUDname to "FLGHT CTRL".}
              if typename = Cntrltag {set typename to "control srf". set HUDname to  "CNTRL SURF".}
              if typename = engtag {set typename to "Engines". set HUDname to  " ENGINES  ".}
              if typename = dcptag {set typename to "Decoupler". set HUDname to  "DECOUPLERS".}
              if typename = geartag {set typename to "Gear". set HUDname to  "   GEAR   ".}
              if typename = chutetag {set typename to "Parachute". set HUDname to  "PARACHUTES".}
              if typename = ladtag {set typename to "Ladder". set HUDname to  "  LADDER  ".}
              if typename = baytag {set typename to "Cargo Bay". set HUDname to  "CARGO BAYS".}
              if typename = Docktag {set typename to "Docking Port". set HUDname to  "  DOCKING ".}
              if typename = RWtag {set typename to "Reaction Wheel". set HUDname to  " RCTNWHEEL".}
              if typename = slrtag {set typename to "Solar Panel"  . set HUDname to  "SOLAR PNLS".}
              if typename = RCStag {set typename to "RCS". set HUDname to  "   RCS    ".}
              if typename = drilltag {set typename to "Drill". set HUDname to  "  DRILLS  ".}
              if typename = radtag {set typename to "Radiator". set HUDname to  " RADIATORS".}
              if typename = scitag {set typename to "Experiment". set HUDname to  "XPERIMENTS".}
              if typename = anttag {set typename to "Antenna". set HUDname to  " ANTENNAS ".}
              if typename = FWtag {set typename to "Firework". set HUDname to  " FIREWRKS ".}
              if typename = ISRUtag {set typename to "Converter". set HUDname to  "   ISRU   ".}
              if typename = Labtag {set typename to "Science Lab". set HUDname to  " SCI-LAB  ".}
              if typename = RBTtag {set typename to "Robotics". set HUDname to  " ROBOTICS ".}
              //MKS MOD
              if typename = MksDrltag {set typename to "MKS Harvest". set HUDname to " MKS HRVST".}
              if typename = PWRtag {set typename to "MKS Resources". set HUDname to  " MKS RSC  ".}
              if typename = DEPOtag {set typename to "MKS Depot". set HUDname to  " MKS DPOT ".}
              if typename = habtag {set typename to "MKS Deployable". set HUDname to  " MKS DPLY ".}
              if typename = Cnsttag {set typename to "MKS Constructor". set HUDname to  " CONSTRCT ".}
              if typename = Dcnsttag {set typename to "MKS Deconstructor". set HUDname to  " DCNSTRCT ".}
              if typename = ACDtag {set typename to "MKS Academy". set HUDname to  " MKS ACDMY".}
              //OTHER MODS
              if typename = Captag {set typename to "Capacitor". set HUDname to  "CAPACITOR ".}
              if typename = BDPtag {set typename to "BD Pilot". set HUDname to  " BD PILOT ".}
              if typename = CMtag {set typename to "Countermeasure". set HUDname to  "CNTRMSURES".}
              if typename = Radartag {set typename to "Radar". set HUDname to  "  RADAR   ".}
              if typename = FRNGtag {set typename to "Fairing". set HUDname to  "  FAIRING ".}
              if typename = WMGRtag {set typename to "Weapon Manager". set HUDname to  " WEAPONS  ".}
              ItemListHUD:add(HUDname).
            }
            if DbgLog > 2{ 
              log2file("dsplist:"+typename ).
              log2file(+"    Tgin:"+Tgin+" typename:"+typename+" lnc:"+lnc+" opin:"+opin ).
            }
          FOR i IN RANGE(1, tgin+1) {

              local t to list(                             " TURN ON  "," TURN OFF ","          ","          ","          ","          ","          ","          ").  
              if typename ="Ladder" 
              or typename = "control srf" 
              or typename =  "Solar Panel"  {set t to list("  EXTEND  ","  RETRACT ","          ","          ","          ","          ","          ","          ").}else{
              if typename ="Decoupler" {set t to      list(" DECOUPLE ","DECOUPLED "," XFEED OFF"," XFEED ON "," INFLATE  "," DEFLATE  ","          ","          ").}else{ 
              if typename ="Antenna" {set t to        list("  EXTEND  ","  RETRACT ","          ","          ","XMIT DATA ","XMIT DATA ","          ","          ").}else{ 
              if typename ="Gear" {set t to           list("  EXTEND  ","  RETRACT ","          ","          "," ENAB STR ","DISAB STR ","          ","          ").} else{
              if typename ="Cargo Bay" {set t to      list("   OPEN   ","   CLOSE  ","          ","          ","          ","          ","          ","          ").} else{
              if typename ="Parachute" {set t to      list("   ARM    ","   ARMED  ","    CUT   ","    CUT   ","          ","          ","          ","          ").} else{
              if typename ="Drill" {set t to          list("  EXTEND  ","  RETRACT ","  TOGGLE  ","  TOGGLE  ","          ","          ","          ","          ").} else{
              if typename ="Experiment"  {set t to    list(" RUN TEST "," RUN TEST ","  DEPLOY  ","  RETRACT ","          ","          ","          ","          ").} else{
              if typename ="Lights"      {set t to    list(" LIGHT OFF"," LIGHT ON ","          ","          ","          ","          ","          ","          ").} else{
            if typename = "Docking Port"{set t to    list("NOT DOCKED"," SEPERATE ","  EXTEND  ","  RETRACT "," XFEED OFF"," XFEED ON ","          ","          ").} else{
              if typename = "Converter"  {set t to    list("  TOGGLE  ","  TOGGLE  ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "firework"   {set t to    list("   FIRE   ","   FIRE   ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "Robotics"   {set t to    list(" TGL DPLY "," TGL DPLY "," TGL LOCK "," TGL LOCK ","          ","          ","          ","          ").} else{
              if typename = "Capacitor"  {set t to    list("DISCHARGE ","DISCHARGE "," CHG ENAB "," CHG ENAB "," CHG DISAB"," CHG DISAB","          ","          ").} else{
              if typename = "Radar"      {set t to    list(" TURN ON  "," TURN OFF ","PREV TRGT ","PREV TRGT ","NEXT TRGT ","NEXT TRGT ","          ","          ").} else{
          if typename = "Reaction Wheel"{set t to    list(" TURN ON  "," TURN ON  "," TURN OFF "," TURN OFF ","          ","          ","          ","          ").} else{
              if typename = "Science Lab"{set t to    list("XMIT SCNCE","XMIT SCNCE","STRT RSRCH","STOP RSRCH","          ","          ","          ","          ").} else{
              if typename = "Countermeasure"{set t to list("   FIRE   ","   FIRE   ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "Fairing"    {set t to    list(" JETTISON "," JETTISON ","          ","          ","          ","          ","          ","          ").} else{
              if typename ="MKS Harvest" {set t to    list("  EXTEND  ","  RETRACT "," STRT DRL "," STOP DRL ","          ","          ","          ","          ").} else{
              if typename = "MKS Depot"  {set t to    list(" ESTABLISH","          ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "MKS Deployable"{set t to list("  DEPLOY  ","  DEPLOY  ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "MKS Resources"{set t to  list("  START   ","   STOP   ","          ","          ","          ","          ","          ","          ").} else{
              if typename = "MKS Academy"  {set t to  list("  TRAIN   "," TRAINING "," LEVEL UP "," LEVEL UP ","          ","          ","          ","          ").} else{
            if typename = "MKS Constructor"{set t to  list(" CONSTRCT "," CONSTRCT "," FABRICTE "," FABRICTE ","ENAB CNSTR","ENAB CNSTR","          ","          ").} else{
            if typename ="Flight Control"  {set t to list(" TURN ON  "," TURN OFF ","          ","          "," DSP HERE ","ALWAYS DSP","          ","          ").} else{
          if typename = "MKS Deconstructor"{set t to list(" DECNSTRCT"," DECNSTRCT","          ","          ","          ","          ","          ","          ").} else{
          if typename = "Weapon Manager"{set t to    list("   FIRE   ","   FIRE   "," TGL GUARD"," TGL GUARD","  CHF/FLR "," CHF/FLR  ","          ","          ").} else{
          if typename = "BD Pilot"{       set t to    list(" TURN ON  "," TURN OFF "," STDBY OFF"," STDBY ON ","  CLAMPED ","UNCLAMPED ","          ","          ").} else{
              if typename = "Engines" and i < tgin+1{
                local k to i. if i > tgin-1 set k to tgin-1.
                FOR j IN RANGE(1, prtlist[lnc][k][0]) {
                  local prt2 to prtlist[lnc][k][J].
                      if prt2:hasmodule("MultiModeEngine"){if not t:contains("TOGL MODE "){set t[2]to "TOGL MODE ".set t[3] to"TOGL MODE ".}}
                      if prt2:hasmodule("ModuleGimbal"){if not t:contains(" TGL GMBL "){set t[4]to " TGL GMBL ".set t[5] to" TGL GMBL ".}}
                      }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
              t:insert(0, t:length). 
              GrpOpsList[lnc]:add(t).
              
              if i = 1{
                local ladd1 to list(1).
                local ladd3 to list(1).
                local ladd5 to list(1).
                local ladd0 to list(t[0]).
                local laddu0 to list(15).
                local laddu1 to list(15).
                for l in range (0,tgin+1){
                  ladd0:add(0).
                  ladd1:add(1).
                  ladd3:add(3).
                  ladd5:add(5).
                  laddu0:add(0).
                  laddu1:add(1).
                }
               GrpDspList:add(ladd1:copy).
              GrpDspList2:add(ladd3:copy).
              GrpDspList3:add(ladd5:copy).
              if opin = 1{
                AutoDspList:add(laddu1:copy).
                autoRstList:add(laddu1:copy).
                AutoValList:add(laddu0:copy).
                AutoRscList:add(laddu0:copy).
                AutoTRGList:add(laddu1:copy).
                AutoRscList[0]:add(1).
                AutoTRGList[0]:add(laddu0:copy).
              }
            }
          }
          
        }
    FUNCTION AutoTag{
      if DbgLog > 0  log2file("AUTOTAG" ).
     if colorprint > 0 PRINT "  " AT (80,1).
      print printrow(GetColor("Setting Auto Tags.","WHT",0)).  
      local loadp to 17. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
      local cnt2 to 0.
          for m in autotaglist{set loadp to loadp+1. print "." at (loadp,LNstp-1).
            set cnt to 1.
            if SHIP:MODULESNAMED(m):length <> 0 {
              FOR prt IN PrtListIn {
                  IF prt:hasmodule("ModuleScienceExperiment") {
                    local pm to prt:GETmodule("ModuleScienceExperiment").
                    IF pm:HASACTION("log pressure data") SET senselist[3] TO 1.
                    IF pm:HASACTION("log gravity data")  SET senselist[1] TO 1.
                    IF pm:HASACTION("log temperature")   SET senselist[4] TO 1.
                    IF pm:HASACTION("log seismic data")  SET senselist[0] TO 1.
                  }
                  IF prt:hasmodule("ModuleGPS") {
                    if prt:TAG = ""  set prt:TAG to prt:TITLE+cnt.
                    IF prt:GETmodule("ModuleGPS"):HASfield("biome") {SET senselist[5] TO 1. set BSensor to prt. }
                  }
                  IF prt:hasmodule("ModuleDeployableSolarPanel") OR prt:hasmodule("KopernicusSolarPanel") SET senselist[2] TO 1.
                  IF prt:hasmodule("CMDropper")  cmlist:add(prt).
                if prt:TAG = "" {
                IF prt:hasmodule("ModuleGPS") {set prt:TAG to prt:TITLE+cnt.}
                else{
                  IF sciModAlt:contains(m){ if prt:hasmodule(m) {set cnt2 to cnt2+1. set prt:TAG to CNT2+":"+prt:TITLE.}}
                  ELSE{
                    IF prt:hasmodule("CMDropper"){set prt:TAG to prt:TITLE.}
                      ELSE{
                        if prt:hasmodule(m){
                          set prt:TAG to prt:TITLE+cnt. 
                          for wd in trimwords{
                            set prt:TAG to Removespecial(prt:TAG,wd).
                          }
                          set cnt to cnt+1.}}}}			 
                if dbglog > 1 and prt:TAG <> "" log2file("   "+prt+"-"+prt:TAG).
                }														
              }
            }
          }
          LOCAL SENSORPRINT TO "Sensors Found:".  
                  IF senselist[3] = 1 SET SENSORPRINT TO SENSORPRINT+"Pressure,".
                  IF senselist[1] = 1 SET SENSORPRINT TO SENSORPRINT+"Gravity,".
                  IF senselist[4] = 1 SET SENSORPRINT TO SENSORPRINT+"Temperature,".
                  IF senselist[0] = 1 SET SENSORPRINT TO SENSORPRINT+"Acceleration,".
                  IF senselist[2] = 1 SET SENSORPRINT TO SENSORPRINT+"Light,".
                  if SENSORPRINT <> "Sensors Found:" printrow(SENSORPRINT).
                  global alltagged to ship:ALLTAGGEDPARTS():copy.
                  global PrtListcur to SetPartList(ship:ALLTAGGEDPARTS()).
    }
    function checkmodeavail{
                    if colorprint > 0 PRINT "  " AT (80,1).
                    IF senselist[3] = 0 SET AutoValList[0][0][3][8]  TO -1.
                    IF senselist[1] = 0 SET AutoValList[0][0][3][11] TO -1. 
                    IF senselist[4] = 0 SET AutoValList[0][0][3][10] TO -1.
                    IF senselist[0] = 0 SET AutoValList[0][0][3][12] TO -1.
                    IF senselist[2] = 0 SET AutoValList[0][0][3][9]  TO -1.
                    IF DCPTAG       = 0 SET AutoValList[0][0][3][15] TO -1.
    }
    Function DcpGauges{
      local parameter Taglist.
      local dcpprt to list("").
      local prt to 0.
      global DcpPrtList to list("0").
      FOR i IN RANGE(1, Taglist[0]+1) {
        DcpPrtList:add(list()).
        FOR j IN RANGE(1, PrtList[dcptag][I][0]+1) {
            set prt to PrtList[dcptag][I][J]. 
           if prt:hassuffix("children") if prt:children:empty = false{set dcpprt to prt:children.}else{set dcpprt to list("").}
          if j=1 DcpPrtList[I]:add(PrtList[dcptag][I][0]).
          for itm in dcpprt {
          IF not DcpPrtList[I]:contains(itm) and itm <> "" DcpPrtList[I]:add(itm).}
        }
        if DcpPrtList[I]:length = 1 DcpPrtList[I]:add("").
      }
      
    }
    function SetModules {
      local loadp to 24. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}

      FOR i IN RANGE(1, ItemList[0]+1) {
        if DbgLog > 0 log2file("SET MODULES:"+ITEMLIST[I] ).
                  set loadp to loadp+1. print "." at (loadp,LNstp-1).
          if i = lighttag  {modulelist:add(list("Action"      ,"ModuleLight"           ,"lights on"          ,"lights off"         ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list("Action"      ,"ModuleNavLight"        ,"turn light on"      ,"turn light off"     ,""                        ,""                 ,""                  ,""             ,""         ,""         )). 
                         modulelistRpt:add(list("light status","light status"          ," TURNED ON "        ," TURNED OFF "       ,"off"                     ," TURNED ON "      ," TURNED OFF "      ,""             ,""         ,""         )).}else{ 
          //good3
          if i = engtag    {modulelist:add(list("Event"  ,"ModuleEnginesFX"              ,"activate engine"   ,"shutdown engine"    ,"MultiModeEngine"         ,"Toggle Mode"      ,"Toggle Mode"       ,"ModuleGimbal","toggle gimbal" ,"toggle gimbal"         )).
                         modulelistAlt:add(list("Event"  ,"ModuleEngines"               ,"activate engine"    ,"shutdown engine"    ,""                        ,""                 ,""                  ,""             ,""              ,""         )).
                         modulelistRpt:add(list(" "      ,"Status"                      ," ACTIVATED "        ," SHUT DOWN "        ,"mode"                    ," MODE TOGGLED"    ,"MODE TOGGLED"      ,"gimbal"       ,"GIMBAL TOGGLED","GIMBAL TOGGLED")).}else{
          //good2
          if i = ladtag    {modulelist:add(list("Event"  ,"RetractableLadder"           ,"extend ladder"     ,"retract ladder"     ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," EXTENDED"         ," RETRACTED"         ,""                        ,""                 ,""                  ,""             ,""         ,""         )).}else{
          //good2
          if i = DcpTag    {modulelist:add(list("Event"  ,"ModuleDecouple"              ,"decouple"          ,""                    ,"ModuleToggleCrossfeed"  ,"Enable Crossfeed" , "disable crossfeed" ,"ModuleAnimateGeneric" ,""         ,""         )).
                         modulelistAlt:add(list("Event"  ,"ModuleAnchoredDecoupler"     ,"decouple"          ,""                    ,""                       ,""                 ,""                   ,""                     ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," DECOUPLED"        ," ATTACHED"           ,""                        ,"CROSSFEED ENABLED","CROSSFEED DISABLED",""                     ,""         ,""         )).
                         }else{         
          //good3
          if i = geartag   {modulelist:add(list("Action" ,"ModuleWheelDeployment"       ,"extend/retract"    ,"extend/retract"     ,"ModuleWheelSteering"     ,"toggle steering"  ,"toggle steering"   ,"ModuleWheelSteering" ,"toggle steering"  ,"toggle steering"   ,""             ,""         ,""         )).
                         modulelistAlt:add(list("Event"  ,"ModuleAnimateGeneric"        ,"extend"            ,"retract"            ,""                        ,""                 ,""                  ,""                    ,""                 ,""                  ,""             ,""         ,""         )). 
                         modulelistRpt:add(list("state"  ,"state"                       ," EXTENDED"         ," RETRACTED"         ,"Retracted"               ,""                 ,""                  ,"steering"            ,"STEERING ENABLED" ,"STEERING DISABLED" ,""             ,""         ,""         )).}else{
          //good2
          if i = baytag    {modulelist:add(list("Event"  ,"ModuleAnimateGeneric"        ,"open"              ,"close"              ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list("Event"  ,"hangar"                      ,"open gates"        ,"close gates"        ,""                        ,""                 ,""                  ,""             ,""         ,""         )). 
                         modulelistRpt:add(list(" "      ,"STATUS"                      ," OPENED"           ," CLOSED"            ,""                        ,""                 ,""                  ,""             ,""         ,""         )).}else{
          //good2
          if i = chutetag  {modulelist:add(list("Action" ,"RealChuteModule"             ,"arm parachute"     ,"disarm parachute"  ,"RealChuteModule"          ,"cut chute"        ,"cut chute"         ,"RealChuteModule","deploy chute","deploy chute",""             ,""         ,""         )).
                         modulelistAlt:add(list("Event"  ,"moduleparachute"             ,"deploy chute"      ,"disarm"             ,"moduleparachute"         ,"cut chute"        ,"cut chute"         ,""               ,""            ,""            ,""             ,""         ,""         )). 
                         modulelistRpt:add(list(" "      ,"altitude"                    ," ARMED"            ," DISARMED"          ,"safe to deploy?"         ," CHUTE CUT"       ," CHUTE CUT"        ,""               ,""            ,""            ,""             ,""         ,""         )).}else{
          //good2
          if i = slrtag    {modulelist:add(list("Event"  ,"ModuleDeployableSolarPanel"  ,"extend Solar Panel","retract Solar Panel","ModuleResourceConverter" ,"deploy scanner"  ,"deploy scanner"     ,""             ,""         ,""         )).
                         modulelistAlt:add(list("Action" ,"ModuleResourceConverter"     ,"start fuel cell"   ,"STOP fuel cell"     ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,"Sun exposure"                ," ENABLED"          ," DISABLED"          ,""                        ,""                 ,""                  ,""             ,""         ,""         )).}else{
          //good
          if i = drilltag  {modulelist:add(list("Event"  ,"ModuleAnimationGroup"        ,"deploy drill"      ,"retract drill"      ,""                        ,""                        ,""                        ,"ModuleOverheatDisplay",""         ,""         )).
                         modulelistAlt:add(list("Action" ,""                            ,""                  ,""                   ,"ModuleResourceHarvester" ,"toggle surface harvester","toggle surface harvester",""                     ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," DEPLOYED"," RETRACTED","ore rate"                ," TOGGLED        "        ," TOGGLED           "      ,"core temp"           ,""         ,""         )).}else{
          //good2
          if i = radtag    {modulelist:add(list("Event"  ,"ModuleDeployableRadiator"    ,"extend radiator"   ,"retract Radiator"   ,"ModuleSystemHeatRadiator","activate radiator","shutdown radiator" ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                 ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," EXTENDED"         ," RETRACTED"         ,"cooling"                 ," ACTIVATED      " ,"DEACTIVATED"       ,""             ,""         ,""         )).}else{
          //GOOD3                        (add collect science to cmd pod //didnt work)
          if i = scitag    {modulelist:add(list("Action" ,"ModuleScienceExperiment"     ,"getname"           ,"getname"            ,""  ,""                  ,""                   ,"" ,""," "         )).
                         modulelistAlt:add(list("Event"  ,""                            ,""                  ,""                   ,"ModuleAnimationGroup"   ,"deploy"            ,"retract"          ,"ModuleScienceExperiment" ,"delete data"," " )).
                         modulelistRpt:add(list(" "      ,""                            ," RUN"              ," DELETED"           ,""                       ,"DEPLOYED"                 ,"RETRACTED" ,""                        ,"DELETED"    ," ")).}else{
          //good2                           (add xmit all science//nope)
          if i = anttag    {local antoff to "off". if rtech = 0 set antoff to "retracted".
                         modulelist:add(list("Event" ,"ModuleDeployableAntenna"         ,"extend antenna"    ,"retract antenna"    ,"ModuleAnimateGeneric"    ,"extend antennas" ,"retract antennas"   ,"ModuleDataTransmitter","transmit data","transmit data,")).
                         modulelistAlt:add(list("Action" ,"ModuleRTAntenna"             ,"activate"          ,"deactivate"         ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list("Status" ,"Status"                      ," EXTENDED"         ," RETRACTED",antoff                     ,""                ,""                   ,""             ,""         ,""         )).}else{
         //Good2
         if i = Docktag    {modulelist:add(list("Event"  ,"ModuleDockingNode"           ,"undock"         ,"undock"                ,"ModuleAnimateGeneric"        ,"open"              ,"close"              ,"ModuleToggleCrossfeed"    ,"Enable Crossfeed" , "disable crossfeed")).
                         modulelistAlt:add(list(""       ,"ModuleGrappleNode"           ,"undock"         ,"undock"                ,""                            ,""                  ,""                   ,""                         ,""                 ,""         )).
                         modulelistRpt:add(list(" "      ,"Status"                     ," DECOUPLED"      ," ATTACHED"             ,""                            ," OPENED"           ," CLOSED",""                         ,"CROSSFEED ENABLED","CROSSFEED DISABLED"         )).}else{
         //good3
         if i = CntrlTag   {modulelist:add(list("Event"  ,"ModuleControlSurface"        ,"toggle deploy"    ,"toggle deploy"       ,"ModuleControlSurface"    ,"activate control","deactivate control",""             ,""         ,""         )).
                         modulelistAlt:add(list("Action" ,"SyncModuleControlSurface"    ,"toggle deploy"    ,"toggle deploy"       ,"SyncModuleControlSurface","activate control","deactivate control",""             ,""         ,""         )).
                         modulelistRpt:add(list("Deploy" ,""                            ," EXTENDED"        ," RETRACTED"          ,"False"                   ," ENABLED"         ," DISABLED",""             ,""         ,""         )).}else{
         //good2
         if i = ISRUTag    {modulelist:add(list("Action" ,"ModuleISRU"                  ,"start isru "       ,"start isru "        ,"ModuleOverheatDisplay"   ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," CONVERTING"       ," NOT CONVERTING"    ,"Core Temp"               ,""                ,""                   ,""             ,""         ,""         )).}else{
         //good2
         if i = CapTag     {modulelist:add(list("Action"  ,"DischargeCapacitor"          ,"discharge capacitor","enable recharge"  ,"DischargeCapacitor"     ,"enable recharge" ,"enable recharge"  ,"DischargeCapacitor","disable recharge","disable recharge")).
                         modulelistAlt:add(list(""       ,""                            ,""                    ,""                 ,""                       ,""                ,""                   ,""                ,""                ,""         )).
                         modulelistRpt:add(list(" "      ,"Status"                      ," DISCHARGING"        ," CHARGING"        ,""                       ," CHARGE ENABLED "," CHARGE ENABLED   ",""                ,"CHARGE DISABLED   ","CHARGE DISABLED   ")).}else{
        //good3
        if i = Radartag    {modulelist:add(list("Event"  ,"ModuleRadar"                 ,"enable radar"      ,"disable radar"      ,""                        ,""                 ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list("Action" ,""                            ,""                  ,""                   ,"ModuleRadar"             ,"target PREV"    ,"target PREV"         ,"ModuleRadar"  ,"target next" ,"target next"         )).
                         modulelistRpt:add(list(" "      ,"current locks"               ," RADAR ON"," RADAR OFF",""                        ," PREVIOUS TARGET"," PREVIOUS TARGET"   ,""             ," NEXT TARGET"," NEXT TARGET"         )).}else{
        //NOT WORKING cant fix until duplicat field names is fixed // worked around
         if i = rwtag      {modulelist:add(list("Action" ,"ModuleReactionWheel"         ,"activate wheel"  ,"activate wheel"     ,"ModuleReactionWheel"     ,"deactivate wheel","deactivate wheel"   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                 ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," ENABLED          "," ENABLED          ",""                       ," DISABLED"       ,"DISABLED"           ,""             ,""         ,""         )).}ELSE{
        //GOOD3
         if i = FWtag      {modulelist:add(list("Event" ,"ModulePartFirework"           ,"Launch"            ,"Launch"           ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                 ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ,"LAUNCHED","LAUNCHED",""                       ,""                ,""                   ,""             ,""         ,""         )).}ELSE{
         //good3
         if i = RBTTag      {modulelist:add(list("ACTION","ModuleRoboticServoPiston"    ,"toggle piston"     ,""                    ,"ModuleRoboticServoPiston","toggle locked"           ,""                   ,""             ,""         ,""         ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                    ,""                        ,""                        ,""                   ,""             ,""         ,""         ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,"current extension"           ,"MOVING"            ,"MOVING"              ,"locked"                  ,"LOCK TOGGLED   "         ,"LOCK TOGGLED       ",""             ,""         ,""         ,""             ,""         ,""         )).}ELSE{
 
         //GOOD2
        if i = RCStag    {modulelist:add(list("Action"    ,"ModuleRCSFX"                ,"toggle rcs thrust" ,"toggle rcs thrust"  ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list("RCS"    ,""                            ," RCS ON"," RCS OFF","False"                   ,""                ,""                   ,""             ,""         ,""         )).}else{
        //good2
        if i = Labtag   {modulelist:add(list("Action"    ,"ModuleScienceLab"            ,"transmit science"  ,"transmit science"  ,"ModuleScienceConverter"  ,"START RESEARCH"   ,"STOP RESEARCH"     ,"ModuleScienceConverter",""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                  ,""                        ,""                 ,""                   ,""                     ,""         ,""         )).
                         modulelistRpt:add(list("research","LAB STATUS"                  ,"                  "," XMITTING SCIENCE ","inactive"               ," START RESEARCH  "," RESEARCHING       ",""                     ,""         ,""         )).}else{
        //good3
        if i = CMtag    {modulelist:add(list("EVENT"     ,"CMDropper"                   ,"fire countermeasure","fire countermeasure",""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ,"                  "," COUNTERMEASURE OUT",""                        ,""                ,""                   ,""             ,""         ,""         )).}else{
        //good2
        if i =FRNGtag    {modulelist:add(list("EVENT"     ,"ModuleProceduralFairing"    ,"deploy"            ,"deploy"             ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                ,""                   ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ,"DEPLOYED"," DEPLOYED",""                        ,""                ,""                   ,""             ,""         ,""         )).}else{
        //good3
         if i = WMGRtag  {modulelist:add(list("Action"   ,"MissileFire"                 ,"fire guns (hold)","fire guns (hold)"     ,"MissileFire"             ,"toggle guard mode","toggle guard mode" ,"CMDropper" ,"fire countermeasure"  ,"fire countermeasure")).
                         modulelistAlt:add(list(""       ,""                            ,""                  ,""                   ,""                        ,""                 ,""                   ,""            ,""             ,""           )).
                         modulelistRpt:add(list(" "      ,"weapon"                      ," FIRING"," DISABLED","Team"                    ," ACTIVATED","DEACTIVATED",""            ," COUNTERMEASURE OUT"," COUNTERMEASURE OUT")).}else{       
        //good3
          if i = BDPtag    {modulelist:add(list("Event"  ,"BDModulePilotAI"           ,"activate pilot"     ,"deactivate pilot"     ,"BDModulePilotAI"         ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                            ,""                 ,""                     ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                            ," ACTIVATED"," DEACTIVATED",""                        ,""                 ,""                  ,""             ,""         ,""         )).}else{
        //good3
         if i = MksDrlTag  {modulelist:add(list("Event"  ,"ModuleAnimationGroup"       ,"deploy"           ,"retract"               ,"usi_harvester"           ,"togle converter"  ,"toggle converter"  ,"mksmodule"    ,""         ,""         ,"ModuleOverheatDisplay" ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""                 ,""                      ,""                        ,""                 ,""                  ,""             ,""         ,""         ,""                      ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ," DEPLOYED"        ," RETRACTED",""                        ,""                 ,""                  ,"governor"     ,""         ,""         ,"Core Temp"             ,""         ,""         )).}else{

          if i = DEPOtag   {modulelist:add(list("Event"  ,"Wolf_Depotmodule"           ,"establish depot"  ,""                      ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""                 ,""                      ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,"wolf biome"                 ," DEPOT ESTABLISHED"," DEACTIVATED         ",""                        ,""                 ,""                  ,""             ,""         ,""         )).}else{
        //good2
          if i = habtag   {modulelist:add(list("Event"   ,"USIAnimation"               ,"toggle module"    ,"toggle module"         ,"USI_BasicDeployableModule",""                 ,""                  ,""             ,""         ,""         )).
                         modulelistAlt:add(list(""       ,"USI_BasicDeployableModule"  ,"deposit resources","deposit resources"     ,""                        ,""                 ,""                  ,""             ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ,"TOGGLED"          ,"TOGGLED "              ,"paid"                    ,""                 ,""                  ,""             ,""         ,""         )).}else{
        //good2
          if i = CnstTag   {modulelist:add(list("Event"   ,"OrbitalKonstructorModule"  ,"open konstructor" ,"open konstructor"      ,"ModuleKonFabricator"     ,"konfabricator"    ,"konfabricator"     ,"ModuleKonstructionForeman","enable konstruction","enable konstruction")).
                         modulelistAlt:add(list(""       ,""                           ,""              ,""                         ,""                        ,""                 ,""                  ,""                 ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ,"TOGGLED"       ,"TOGGLED"                  ,""             ,""                        ,""                 ,""                  ,""                 ,""         ,""         )).}else{
        //good2
          if i = DcnstTag   {modulelist:add(list("Event"   ,"ModuleDekonstructor"      ,"dekonstructor"    ,"dekonstructor"         ,""                        ,""                 ,""                  ,""                 ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""              ,""                         ,""                        ,""                 ,""                  ,""                 ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ,"       "       ,"        "                 ,""             ,""                        ,""                  ,""                 ,""                 ,""         ,""         )).}else{
        //good2
          if i = PWRtag   {modulelist:add(list("Event"   ,"usi_converter"              ,"start reactor"     ,"stop reactor"         ,"ModuleOverheatDisplay"    ,""                 ,""                 ,"mksmodule"  ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""                  ,""                     ,""                        ,""                 ,""                  ,""            ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ," STARTED"          ," STOPPPED"            ,"Core Temp"                ," "                ,""                 ,"governor"           ,""         ,""         )).}else{
        //good2                                                           
          if i = ACDtag   {modulelist:add(list("Event"   ,"spaceacademy"               ,"conduct training"  ,"conduct training"    ,"ModuleExperienceManagement","level up crew"    ,"level up crew"    ,""            ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""                  ,""                    ,""                          ,""                 ,""                 ,""            ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ,"             "     ,"             "       ,""                          ," "                ,""                 ,""            ,""         ,""         )).}
        //good3                                                           
          if i = AGtag or i = Flytag  {modulelist:add(list("AG"       ,"AG"                         ,""                  ,""    ,"",""    ,""   ,""            ,""         ,""         )).
                         modulelistAlt:add(list(""       ,""                           ,""                  ,""                    ,""                          ,""                 ,""                 ,""            ,""         ,""         )).
                         modulelistRpt:add(list(" "      ,""                           ," TURNED ON",               " TURNED OFF",                ""                          ," "                ,""                 ,""            ,""         ,""         )).}
                                          
                         else{}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
      }   
    }
    Function CheckSettings{local loadp to 22. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
    if DbgLog > 0 log2file("CHECK SETTINGS" ).
        for I in Range(1,ItemList[0]+1){
          set loadp to loadp+1. print "." at (loadp,LNstp-1).
          for j in Range(1,prtTagList[I][0]+1){
            for k in range (1,4){
              global ModSt to CheckModule(i,j,k).
              if ModSt <> " "{
              if k = 1 set GrpDspList[I][J] to ModSt.
              if k = 2 set GrpDspList2[I][J] to ModSt.
              if k = 3 set GrpDspList3[I][J] to ModSt.
              }
              if i = agtag or i = flytag or i = lighttag break.
              }}}
      }
    function CheckModule {//togglegroup(item tag number, part tag number, option).
      local parameter Inum, tagnum, optn is 1.
      local MDL to modulelist[inum].
      local MDL2 to modulelistAlt[inum].
      local MDL3 to modulelistRPT[inum].
      local opset to 0.
      local optn3 to optn*3.
      local optn2 to optn3-1.
      local optn1 to optn3-2.
      local ans to " ".
      local Module1 to MDL[optn1].
      local Module2 to MDL2[optn1].
      local Event1On to MDL[optn2].
      local Event1Off to MDL[optn3].
      local Event2On to MDL2[optn2].
      local Event2Off to MDL2[optn3].
      
      if Event1On+Event1Off+Event2On+Event2Off <> ""{
        if DbgLog > 0{ 
          log2file("   CHECK MODULE-"+ITEMLIST[Inum]+"("+Inum+")"+PRTTAGLIST[Inum][tagnum]+"("+tagnum+")-"+optn ).
          if dbglog > 2 {
            log2file("     modulesPri:-"+LISTTOSTRING(MDL) ).
            log2file("     modulesAlt:-"+LISTTOSTRING(MDL2) ).
            log2file("     Report Val:-"+LISTTOSTRING(MDL3) ).
          }
        }
          if inum = AGTag {set opset to 1.
            if tagnum = 1  and ag1  = True {set opset to 2.}else{
            if tagnum = 2  and ag2  = True {set opset to 2.}else{
            if tagnum = 3  and ag3  = True {set opset to 2.}else{
            if tagnum = 4  and ag4  = True {set opset to 2.}else{
            if tagnum = 5  and ag5  = True {set opset to 2.}else{
            if tagnum = 6  and ag6  = True {set opset to 2.}else{
            if tagnum = 7  and ag7  = True {set opset to 2.}else{
            if tagnum = 8  and ag8  = True {set opset to 2.}else{
            if tagnum = 9  and ag9  = True {set opset to 2.}else{
            if tagnum = 10 and ag10 = True {set opset to 2.}else{
            if tagnum = 11 and THROTTLE > 0 {set opset to 2.}else{
            if tagnum = 12 and RCS = False {set opset to 2.}}}}}}}}}}}}
          }else{
          if inum = FlyTag {
            set opset to 1.
            IF tagnum = 1 {if steeringmanager:enabled = TRUE set OPSET to 2.}
            ELSE{
              if sasmode =  Removespecial(prtTagList[Flytag][tagnum]," ") and SAS = true {set opset to 2. set StrLock to tagnum.}
            }
          }
          else{
        local pl to prtList[inum][tagnum].
        set pl to pl:sublist(1, pl:length).
        local p to pl[0].
        local fld to mdl3[0]. 
        local op to mdl3[4]. 
        local ea1 to MDL[0].
        local ea2 to MDL2[0]. 
            if inum = lighttag and P:hasmodule("modulecommand") set fld to " ".
            if inum = ENGtag {
              IF optn = 1 {
                clearev2().
                local lon to list("on", "activate").
                local loff to list("off","shutdown").
                local Elst to engModAlt.
                if p:hassuffix("modes") if P:modes:length > 1 if not P:primarymode set Elst to list("MultiModeEngine").
                if p:hassuffix("ignition"){if p:ignition = false set loff to list(""). else set lon to list("").}           
                local ccc to getactions("Actions",Elst,inum, tagnum,optn,3,lon,loff).
                if  ccc[3] > 0 SetTrgVars2(CCC,-1).
              }
              if p:hasmodule("ModuleGimbal"){
                IF optn = 3 {set fld to "GIMBAL". set op to False. set ea1 to "Action".set ea2 to "Action".}
              }
            }
            else{
            if inum = geartag{
              if rowval = 0{
                if optn = 3 { set fld to "steering". set op to "False".}
                }
              if rowval = 1{
                if optn = 1 set gearop to 1.
                if optn = 2 set gearop to 7.
                if optn = 3 set gearop to 3.  
                set module1 to GearModLst[0][gearop].
                set module2 to GearModLst[0][gearop].
                set fld to GearModLst[3][gearop].
                set ea1 to GearModLst[4][gearop].
                set op to "aa".
                set ea2 to ea1.
                }
            }
            else{
          if inum = PWRTag {
            local fl to "".
            set fl to prtlist[pwrtag][tagnum][1]:getmodule("usi_converter"):allfieldnames[0]. 
            set Event1On to "start"+fl. 
            set Event1Off to "stop"+fl.
          }
          else{
          if inum = dcptag{
            if optn = 1{
            local ct to 0.
              for pt in pl {
                for md in DcpModAlt{
                  if pt:hasmodule(md){set ct to ct+1.
                    if ct = 1 set module1 to md. 
                    if ct = 2 set module2 to md.
                  }
                }
              }
            }
          }
          else{
            if inum = CNTRLtag {
              if  pl[0]:hasmodule("ModuleAeroSurface")set module1 to "ModuleAeroSurface".
            }
            else{
            if inum = Docktag {
              if optn = 1 if pl[0]:hassuffix("HASPARTNER") IF pl[0]:HASPARTNER = TRUE RETURN 2. ELSE RETURN 1.
              if optn = 2 if PL[0]:hassuffix("STATE") IF PL[0]:STATE ="DISABLED" RETURN 3.
            }ELSE{
            if mks = 1 {
              if inum = MksDrlTag {
                local ccc to getactions("Actions",list("usi_harvester"),inum, tagnum, optn, 0,list("start","activate"),list("stop","deactivate")).
                clearev2().
                if  ccc[3] > 0 SetTrgVars2(CCC,-1).
                }
            }
          }}}}}}
            if fld <>" "{ 
              local ddd to getactions("Actions",list(module1,module2),inum, tagnum,optn,4,list(fld)).
              set opset to ddd[3].
              set module1 to ddd[0]. 
              set module2 to "".
              set fld to ddd[1]. 
              LOCAL FldVal to ddd[2]. 
              if FldVal = op set opset to 1. else set opset to 2. 
              }
                else{
                  if ea1 = "Event" or ea2 = "Event"   set opset to getactions("OnOff",list(module1,module2),inum, tagnum,optn,1,list(Event1On,Event2On),list(Event1Off,Event2Off)).
                if opset = 0 {
                  if ea1 = "Action" or ea2 = "Action" set opset to getactions("OnOff",list(module1,module2),inum, tagnum,optn,3,list(Event1On,Event2On),list(Event1Off,Event2Off)).}
                  }}}
                  if opset = 1 {
                    if optn =1  SET ans TO 1.
                    IF optn =2 SET ans TO 3.
                    IF optn =3 SET ans TO 5.
                    SET ANS2 TO "OFF".
                  }
                  if opset = 2 {                  
                    if optn =1  SET ans TO 2.
                    IF optn =2 SET ans TO 4.
                    IF optn =3 SET ans TO 6.
                    SET ANS2 TO "ON".
                  }
                  if dbglog > 1 {
                    log2file("      "+"Module1:"+ MDL[optn1]+" Module2:"+ MDL2[optn1] ).
                    log2file("      "+" Event2On:"+ MDL2[optn2]+" Event2Off:"+ MDL2[optn3]).
                    log2file("      "+" Event1On:"+ MDL[optn2]+" Event1Off:"+ MDL[optn3]).
                  if DbgLog > 1 AND ANS:TYPENAME <> "STRING" log2file("      "+mdl3[ans]+"("+ANS2+")").
                }
      
    }  
                return ans.
      }
          function SetTrgVars2{
            local parameter inlst,fldin is 0, evactin is 0.
            if DbgLog > 1 log2file("     SETTRGVARS2-MODULE:"+INLST[0]+" EVENT1ON:"+EVENT1ON+" EVENT1OFF:"+EVENT1OFF).
            if evactin = 0 set ea1 to inlst[4].
              if inlst[0] <> "" and inlst[0] <> module2 set module1 to inlst[0]. 
              if inlst[1] <> "" and inlst[1] <> Event2On  set Event1On  to inlst[1].
              if inlst[2] <> "" and inlst[2] <> Event2Off set Event1Off to inlst[2]. 
            if fldin > -1{
              if fldin = 0 set fld to " ". else set fld to fldin.
            }
          }
          function clearev2{
            set event1on to "". set event1off to "". set module1 to "".
            set event2on to "". set event2off to "". set module2 to "".
          }
  }
function printrow{
      local parameter var, wt is 2.
      set lns to floor((var:length/(widthlim-2))+1).
      if  LNstp = 8 or LNstp = 7 {
        print "                                        " at (20,8). 
        print "                                        " at (20,9). 
        print "                                        " at (20,10). 
      }
      if LNstp = 14 or LNstp+lns > 14 {
      if wt = 0 return 1. else print "More in "+wt+" seconds..." at (1,LNstp). 
      if (FASTBOOT = 0 AND loadattempts > 3) or wt <> 2 wait wt. 
      if wt = 2{
      for z in range(1,LNstp+1) print "|"+Bigempty2+"|" at(0,z). 
      set LNstp to 1.
      }
      }
      print var at (1,LNstp).
      if DbgLog > 0 log2file("  PRINTROW:"+var ).
      set LNstp to LNstp+lns.
      return 0.
    }
function ISRUcheck{
      if ISRUTag <> 0 {
      set isruoptlst to list().
      for i in range (1,5){
        if i < 5 {local t to prtList[ISRUTag][1][1]:getmodulebyindex(i):allfieldnames[0].
          if not isruoptlst:contains(t) isruoptlst:ADD(t).
        }
      }
      isruoptlst:insert(0, isruoptlst:length).}
        if PWRTag <> 0 set mks to 1.
        if HABTag <> 0 set mks to 1.
        if DEPOTag <> 0 set mks to 1.
        if MksDrlTag <> 0 set mks to 1.
          set RBTModLst to LIST(list("","ModuleRoboticServoPiston","ModuleRoboticServoRotor","ModuleRoboticServoHinge","ModuleRoboticRotationServo"),
                                list("","toggle piston"           ,"toggle motor power"     ,"toggle hinge"           ,"toggle servo"),
                                list("","current extension"       ,"current rpm"            ,"current angle"          ,"current angle"),
                                list("","force limit(%)"          ,"torque limit(%)"        ,"torque limit(%)"        ,"torque limit(%)"),
                                list("","target extension"        ,"rpm limit"              ,"target angle"           ,"target angle"),
                                list("","0/5/.05"                  ,"0/460/10"              ,"-180/180/5"             ,"-180/180/5")).

          set GearModLst to LIST(list("","ModuleWheelSuspension"  ,"ModuleWheelSuspension"   ,"ModuleWheelSteering"      ,"ModuleWheelSteering"      ,"ModuleWheelSteering"      ,"ModuleWheelBrakes"      ,"ModuleWheelBase"),
                                list("","spring/damper: auto"     ,"spring/damper: auto"     ,"steering adjust: auto"    ,"steering adjust: auto"    ,"steering adjust: auto"    ,"brake"                  ,"friction control: auto"),
                                list("","spring/damper: override" ,"spring/damper: override" ,"steering adjust: override","steering adjust: override","steering adjust: override","brake"                  ,"friction control: override"),
                                list("","spring strength"         ,"damper strength"         ,"steering angle limiter"   ,"steering response"        ,"steering: direction"      ,"brakes"                 ,"friction control"),
                                list("","Event"                   ,"Event"                   ,"Event"                    ,"Event"                    ,"Field"                    ,"Action"                 ,"Event"),
                                list("","0.05/3/.05"              ,"0.05/2/.05"              ,"0/30/1"                   ,"0.1/10/0.1"               ,"False/True/1"             ,"0/200/5"                ,"0/10/0.1")).

          set BDPModLst to LIST(list("","default alt." ,"min altitude" ,"steer factor"  ,"steer ki"   ,"STEER LIMITER","steer damping"  ,"max speed" ,"takeoff speed" ,"mincombatspeed" ,"idle speed" ,"max g"     ,"max aoa" ),
                                list("","500/15000/50" ,"150/6000/50"  ,"0.05/1/.05"    ,"0.05/1/.05" ,"0.05/1/.05"   ,"1/8/.5"         ,"20/800/10" ,"10/200/5"      ,"20/200/5"       ,"10/200/5"   ,"2/45/.25"  ,"0/85/.5" ),
                                list("","500/100000/50","150/30000/50" ,"0.05/200/.05"  ,"0.05/20/.05","0.05/1/.05"   ,"1/100/.5"       ,"20/3000/10","10/2000/5"     ,"20/2000/5"      ,"10/3000/5"  ,"2/1000/.25","0/180/.5")).
       
          //set ANTModLst to LIST(list("","target","activate at ec %" ,"deactivate at ec %"),
          //                      list("","0,1,1","0/100/5" ,"0/100/5")).


          set KALModLst to LIST(list("","toggle play"             ,"toggle loop mode"       ,"toggle direction"       ,"toggle controller enabled"),
                                list("","play/pause"              ,"loop mode"              ,"play direction"         ,"enabled"                  ),
                                list("","play position"           ,""                       ,""                       ,""                         ),
                                list("","play speed"              ,""                       ,""                       ,""                         ),
                                list("","0/100/.5"                ,"0/460/10"              ,"-180/180/5"             ,"-180/180/5")).

          set CHUTEModLst to LIST(list("","min pressure"   ,"altitude"     ,"spread angle"  ,"deploy mode"),
                                  list("","0.01/0.75/0.01" ,"50/5000/50"   ,"0/10/1"        ,"0/2/1"),
                                  list(""," kPa"           ," M"          ," "              ,"SAFE/RISKY/IMMIDIATE")).
       


      
      local rscl to getRSCList(ship:resources,2).
      global rsclist to rscl[0].
      global RscNum to rscl[1].
      global rsclist2 to rscl[2].
      global prsclist to list("").


    }
function SetPartList{
local parameter lin.
set checktime to time:seconds.
local prtltmp to list().
for prt in lin{
  local opt to checkdcp(prt,"payload").
  if IsPayload[0] = 0 and opt[0] = 0 prtltmp:add(prt).
  if IsPayload[0] = 1 and opt[0] = 1 prtltmp:add(prt).
}
return prtltmp.
}
function getRSCList{
  local parameter lin, opt is 0. 
  if dbglog > 0 log2file("    GET RESOURCE LIST").
  if dbglog > 1 for itm in lin log2file("     "+itm).
  local count to 0.
  local loadp to 23. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
  local RscL to list().
  local RscL2 to list().
  local RscN to lexicon().
  for RSC in lin{
        if opt = 2 {set loadp to loadp+1. print "." at (loadp,LNstp-1).}
      IF rsc:name = "ElectricCharge" {RscL:add(list(rsc:name, "Electric Charge",rsc:capacity,count)). RscN:add(rsc:name,count). IF OPT > 0 set ecmax to rsc:capacity.}else{
      IF rsc:name = "IntakeAir" {RscL:add(list(rsc:name, "Intake Air",rsc:capacity,count)). RscN:add(rsc:name,count).  IF OPT > 0  set airmax to rsc:capacity.}else{          
      IF rsc:name = "XenonGas" {RscL:add(list(rsc:name, "Xenon Gas",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
      IF rsc:name = "LiquidHydrogen" {RscL:add(list(rsc:name, "Liquid Hydrogen",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
      IF rsc:name = "LiquidOxygen" {RscL:add(list(rsc:name, "Liquid Oxygen",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
      IF rsc:name = "LiquidFuel" {RscL:add(list(rsc:name, "Liquid Fuel",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
      IF rsc:name = "SolidFuel" {RscL:add(list(rsc:name, "Solid Fuel",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
        if mks = 1{
          IF rsc:name = "EnrichedUranium" {RscL:add(list(rsc:name, "Enriched Uranium",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "ColonySupplies" {RscL:add(list(rsc:name, "Colony Supplies",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "SpecialisedParts" {RscL:add(list(rsc:name, "Specialised Parts",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "MaterialKits" {RscL:add(list(rsc:name, "Material Kits",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "RefinedExotics" {RscL:add(list(rsc:name, "Refined Exotics",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "DepletedFuel" {RscL:add(list(rsc:name, "Depleted Fuel",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "DepletedUranium" {RscL:add(list(rsc:name, "Depleted Uranium",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "MetallicOre" {RscL:add(list(rsc:name, "Metallic Ore",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "ExoticMinerals" {RscL:add(list(rsc:name, "Exotic Minerals",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "RareMetals" {RscL:add(list(rsc:name, "Rare Metals",rsc:capacity,count)). RscN:add(rsc:name,count).}else{
          IF rsc:name = "SpecializedParts" {RscL:add(list(rsc:name, "Specialized Parts",rsc:capacity,count)). RscN:add(rsc:name,count).}
          else{RscL:add(list( rsc:name, rsc:name,rsc:capacity,count)). RscN:add(rsc:name,count).}}}}}}}}}}}
        }else{ RscL:add(list( rsc:name, rsc:name,rsc:capacity,count)). RscN:add(rsc:name,count).}}}}}}}}
        Rscl2:add(RSCL[count][1]).
    set count to count+1.
  }
  return list(rscl,RscN,RscL2).
}
function loadbar{
SET LOADING TO LOADING+loadperstep.
for st in range(1,loading) print "#" at (st,16).
    if LOADING > widthlim-3 {PRINTLINE("",0,16). set LOADING to 0.}
}
//#endregion
//#region Auto Functions
Function SetAutoTriggers{ 
  if DbgLog > 0 log2file("SET AUTO TRIGGERS:" ).
  local parameter op is 1.
  global AutoItemLst to list(0). 
  global AutotagLstUP to list(0). 
  global AutotagLstDN to list(0).  
  global AutotagLstNAUP to list(0).
  global AutotagLstNADN to list(0).     
  global AutoLst to list(0).
  local loadp to 21.  if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
  for j in range(1,MODESHRT:LENGTH){AutoLst:add(list(0)). AutoItemLst:add(list(0)).
  if op = 2 {set loadp to loadp+1. print "." at (loadp,LNstp-1).}
  if dbglog > 1 log2file("    "+MODELONG[j]). 
  for k in range (1,5){AutoItemLst[J]:add(list(0)). AutoLst[J]:add(list(0)).}
    for u in range(1,3){
      if u = 3 break.
      for i in range (1,itemlist[0]+1){AutoLst[J][u]:add(list(0)). AutoLst[J][u+2]:add(list(0)).
      //if i = itemlist[0]+1 break.
        for t in range (1,prtTAGList[I][0]+1){if t = 1 AND U = 1 and j = 1{AutotagLstUP:add(list(0)). AutotagLstDN:add(list(0)). AutotagLstNAUP:add(list(0)). AutotagLstNADN:add(list(0)).}
        //if t = prtTAGList[I][0]+1 break.
          if AutovalList[I][T] <> 0 and abs(AutoDspList[I][T]) = j{
            IF U = 1 {
              IF AutovalList[I][T] > 0 {
                if AutoDspList[I][T] > 1 {
                  AutoLst[J][U][I]:add(ABS(AutovalList[I][T])).
                  if not AutotagLstUP[I]:contains(t) AutotagLstUP[I]:add(t).
                  if not AutoItemLst[J][U]:contains(i) AutoItemLst[J][U]:add(i).
                }else{
                    AutoLst[J][U+2][I]:add(ABS(AutovalList[I][T])).
                    if not AutotagLstNAUP[I]:contains(t) AutotagLstNAUP[I]:add(t).
                    if not AutoItemLst[J][U+2]:contains(i) AutoItemLst[J][U+2]:add(i). 
                }
              }
              
            }ELSE{
              IF U = 2 {
                IF AutovalList[I][T] < 0 {
                  if AutoDspList[I][T] > 1 {
                    AutoLst[J][U][I]:add(ABS(AutovalList[I][T])).
                    if not AutotagLstDN[I]:contains(t) AutotagLstDN[I]:add(t).
                    if not AutoItemLst[J][U]:contains(i) AutoItemLst[J][U]:add(i). 
                  }else{
                    AutoLst[J][U+2][I]:add(ABS(AutovalList[I][T])).
                    if not AutotagLstNADN[I]:contains(t) AutotagLstNADN[I]:add(t).
                    if not AutoItemLst[J][U+2]:contains(i) AutoItemLst[J][U+2]:add(i). 
                }
                  
                }
              }
            }     
          }
      }
      //SET AutotagLstUP[I][0] TO 0.
      //SET AutotagLstDN[I][0] TO 0.
    }
  }
}
setAutoMinMax().
}
function UpdateAutoTriggers{
  local parameter Updnnum, ModeNum, ItmNum, TgNum, opt is 0.
              if DbgLog > 0 {
                log2file("UPDATEAUTOTRIGGERS:"+Removespecial(MODELONG[modenum])).
                log2file("   Updnnum:"+Updnnum+"-ModeNum:"+ModeNum+"-ItmNum:"+ItmNum+"-TgNum:"+TgNum+"-opt:"+opt ).
                if DbgLog > 1 {
                  log2file("   IF AutovalList[ItmNum][TgNum] > 0:"+ AutovalList[ItmNum][TgNum] ).
                  log2file("   if AutoDspList[ItmNum][TgNum] > 1 and AutoDspList[ItmNum][TgNum] = ModeNum " ).
                  log2file("   if "+AutoDspList[ItmNum][TgNum]+" > 1 and "+AutoDspList[ItmNum][TgNum]+" = "+ModeNum ).
                  log2file("   AutoLst["+ModeNum+"][1]["+ItmNum+"]:"+LISTTOSTRING(AutoLst[ModeNum][1][ItmNum]) ).
                  log2file("   AutoLst["+ModeNum+"][2]["+ItmNum+"]:"+LISTTOSTRING(AutoLst[ModeNum][2][ItmNum]) ).
                  log2file("   AutoLst["+ModeNum+"][3]["+ItmNum+"]:"+LISTTOSTRING(AutoLst[ModeNum][3][ItmNum]) ).
                  log2file("   AutoLst["+ModeNum+"][4]["+ItmNum+"]:"+LISTTOSTRING(AutoLst[ModeNum][4][ItmNum]) ).
                  if AutotagLstUP[ItmNum]:length > 1 log2file("    AutotagLstUP["+ItmNum+"]:"+LISTTOSTRING(AutotagLstUP[ItmNum]) ).
                  if AutotagLstDN[ItmNum]:length > 1 log2file("    AutotagLstDN["+ItmNum+"]:"+LISTTOSTRING(AutotagLstDN[ItmNum]) ).
                  if  AutotagLstNAup[ItmNum]:length > 1 log2file("   AutotagLstNAup["+ItmNum+"]:"+LISTTOSTRING(AutotagLstNAup[ItmNum]) ).
                  if  AutotagLstNADN[ItmNum]:length > 1 log2file("   AutotagLstNADN["+ItmNum+"]:"+LISTTOSTRING(AutotagLstNADN[ItmNum]) ).
                }
              }
            if AutoDspList[ItmNum][TgNum] > 1 and AutoDspList[ItmNum][TgNum] = ModeNum and AutovalList[ItmNum][TgNum] <> 0{
              if not AutoLst[ModeNum][Updnnum][ItmNum]:contains(ABS(AutovalList[ItmNum][TgNum])) AutoLst[ModeNum][Updnnum][ItmNum]:add(ABS(AutovalList[ItmNum][TgNum])).
              if not AutoItemLst[ModeNum][Updnnum]:contains(ItmNum) AutoItemLst[ModeNum][Updnnum]:add(ItmNum).
              IF AutovalList[ItmNum][TgNum] > 0 {
                if not AutotagLstUP[ItmNum]:contains(TgNum) AutotagLstUP[ItmNum]:add(TgNum).
                if AutotagLstDN[ItmNum]:contains(TgNum) AutotagLstDN[ItmNum]:remove(AutotagLstDN[ItmNum]:find(TgNum)).
              }
              IF  AutovalList[ItmNum][TgNum] < 0 {
                if not AutotagLstDN[ItmNum]:contains(TgNum) AutotagLstDN[ItmNum]:add(TgNum).
                if AutotagLstUP[ItmNum]:contains(TgNum) AutotagLstUP[ItmNum]:remove(AutotagLstUP[ItmNum]:find(TgNum)).
              }
              if AutotagLstNADN[ItmNum]:contains(TgNum) AutotagLstNADN[ItmNum]:remove(AutotagLstNADN[ItmNum]:find(TgNum)).
              if AutotagLstNAup[ItmNum]:contains(TgNum) AutotagLstNAup[ItmNum]:remove(AutotagLstNAup[ItmNum]:find(TgNum)).
            }
                if DbgLog > 1{
                  log2file("  post update triggers").
                  if AutotagLstUP[ItmNum]:length > 1 log2file("    AutotagLstUP["+ItmNum+"]:"+LISTTOSTRING(AutotagLstUP[ItmNum]) ).
                  if AutotagLstDN[ItmNum]:length > 1 log2file("    AutotagLstDN["+ItmNum+"]:"+LISTTOSTRING(AutotagLstDN[ItmNum]) ).
                  if  AutotagLstNAup[ItmNum]:length > 1 log2file("   AutotagLstNAup["+ItmNum+"]:"+LISTTOSTRING(AutotagLstNAup[ItmNum]) ).
                  if  AutotagLstNADN[ItmNum]:length > 1 log2file("   AutotagLstNADN["+ItmNum+"]:"+LISTTOSTRING(AutotagLstNADN[ItmNum]) ).
                }

      if opt = 0 UpdateAutoMinMax(ModeNum). else setAutoMinMax(). //maybe check length to to fulll update on values with values using autotaglist lengths..
       //setAutoMinMax().
}
function checkautotrigger{
  local parameter inlist.
  //IF dbglog > 1 log2file("checkautotrigger:"+LISTTOSTRING(INLIST)).
  for itm in inlist if itm <> 0 return 1.
  return 0.
}
function setAutoMinMax{
  if dbglog > 0 log2file("SET AUTO MIN MAX"). 
        set SpdTrgsUP to  minmax(AutoLst[2][1],"SpdTrgsUP").  set SpdTrgsDN to  minmax(AutoLst[2][2],"SpdTrgsDN"). 
        set AltTrgsUP to  minmax(AutoLst[3][1],"AltTrgsUP").  set AltTrgsDN to  minmax(AutoLst[3][2],"AltTrgsDN"). 
        set AGLTrgsUP to  minmax(AutoLst[4][1],"AGLTrgsUP").  set AGLTrgsDN to  minmax(AutoLst[4][2],"AGLTrgsDN"). 
        set ECTrgsUP to   minmax(AutoLst[5][1],"ECTrgsUP").  set ECTrgsDN to   minmax(AutoLst[5][2],"ECTrgsDN"). 
        set RSCTrgsUP to  minmax(AutoLst[6][1],"RSCTrgsUP").  set RSCTrgsDN to  minmax(AutoLst[6][2],"RSCTrgsDN"). 
        set ThrtTrgsUP to minmax(AutoLst[7][1],"ThrtTrgsUP").  set ThrtTrgsDN to minmax(AutoLst[7][2],"ThrtTrgsDN").    
        set PresTrgsUP to minmax(AutoLst[8][1],"PresTrgsUP").  set PresTrgsDN to minmax(AutoLst[8][2],"PresTrgsDN").  
        set SunTrgsUP  to minmax(AutoLst[9][1],"SunTrgsUP").  set SunTrgsDN  to minmax(AutoLst[9][2],"SunTrgsDN").  
        set TempTrgsUP to minmax(AutoLst[10][1],"TempTrgsUP"). set TempTrgsDN to minmax(AutoLst[10][2],"TempTrgsDN"). 
        set GravTrgsUP to minmax(AutoLst[11][1],"GravTrgsUP"). set GravTrgsDN to minmax(AutoLst[11][2],"GravTrgsDN"). 
        set AccTrgsUP  to minmax(AutoLst[12][1],"AccTrgsUP"). set AccTrgsDN  to minmax(AutoLst[12][2],"AccTrgsDN"). 
        set TWRTrgsUP  to minmax(AutoLst[13][1],"TWRTrgsUP"). set TWRTrgsDN  to minmax(AutoLst[13][2],"TWRTrgsDN"). 
        set StsTrgsUP  to minmax(AutoLst[14][1],"StsTrgsUP"). set StsTrgsDN  to minmax(AutoLst[14][2],"StsTrgsDN"). set StsTrgs to GetSTSList(AutoLst[14][1]). 
        set FuelTrgsUP to minmax(AutoLst[15][1],"FuelTrgsUP"). set FuelTrgsDN to minmax(AutoLst[15][2],"FuelTrgsDN").
        logtrgs().
}
function UpdateAutoMinMax{
  local parameter mdnm. 
                if DbgLog > 0 log2file("       UPDATE AUTO MIN MAX - "+ MODELONG[mdnm] ).               
  if mdnm = 2 { set SpdTrgsUP to  minmax(AutoLst[2][1],"SpdTrgsUP").  set SpdTrgsDN to  minmax(AutoLst[2][2],"SpdTrgsDN").}else{
  if mdnm = 3 { set AltTrgsUP to  minmax(AutoLst[3][1],"AltTrgsUP").  set AltTrgsDN to  minmax(AutoLst[3][2],"AltTrgsDN").}else{
  if mdnm = 4 { set AGLTrgsUP to  minmax(AutoLst[4][1],"AGLTrgsUP").  set AGLTrgsDN to  minmax(AutoLst[4][2],"AGLTrgsDN").}else{
  if mdnm = 5 { set ECTrgsUP to   minmax(AutoLst[5][1],"ECTrgsUP").  set ECTrgsDN to   minmax(AutoLst[5][2],"ECTrgsDN").}else{
  if mdnm = 6 { set RSCTrgsUP to  minmax(AutoLst[6][1],"RSCTrgsUP").  set RSCTrgsDN to  minmax(AutoLst[6][2],"RSCTrgsDN").}else{
  if mdnm = 7 { set ThrtTrgsUP to minmax(AutoLst[7][1],"ThrtTrgsUP").  set ThrtTrgsDN to minmax(AutoLst[7][2],"ThrtTrgsDN").}else{
  if mdnm = 8 { set PresTrgsUP to minmax(AutoLst[8][1],"PresTrgsUP").  set PresTrgsDN to minmax(AutoLst[8][2],"PresTrgsDN").}else{
  if mdnm = 9 { set SunTrgsUP  to minmax(AutoLst[9][1],"SunTrgsUP").  set SunTrgsDN  to minmax(AutoLst[9][2],"SunTrgsDN").}else{
  if mdnm = 10{ set TempTrgsUP to minmax(AutoLst[10][1],"TempTrgsUP"). set TempTrgsDN to minmax(AutoLst[10][2],"TempTrgsDN").}else{
  if mdnm = 11{ set GravTrgsUP to minmax(AutoLst[11][1],"GravTrgsUP"). set GravTrgsDN to minmax(AutoLst[11][2],"GravTrgsDN").}else{
  if mdnm = 12{ set AccTrgsUP  to minmax(AutoLst[12][1],"AccTrgsUP"). set AccTrgsDN  to minmax(AutoLst[12][2],"AccTrgsDN").}else{
  if mdnm = 13{ set TWRTrgsUP  to minmax(AutoLst[13][1],"TWRTrgsUP"). set TWRTrgsDN  to minmax(AutoLst[13][2],"TWRTrgsDN").}else{
  if mdnm = 14{ set StsTrgsUP  to minmax(AutoLst[14][1],"StsTrgsUP"). set StsTrgsDN  to minmax(AutoLst[14][2],"StsTrgsDN"). set StsTrgs to GetSTSList(AutoLst[14][1]).}else{
  if mdnm = 15{ set FuelTrgsUP to minmax(AutoLst[15][1],"FuelTrgsUP"). set FuelTrgsDN to minmax(AutoLst[15][2],"FuelTrgsDN").}}}}}}}}}}}}}}
  logtrgs().
}
function logtrgs{
        if DbgLog > 1 {
          log2file("        SpdTrgsUP:"+LISTTOSTRING(SpdTrgsUP) +" SpdTrgsDN:"+LISTTOSTRING(SpdTrgsDN) ). 
          log2file("        AltTrgsUP:"+LISTTOSTRING(AltTrgsUP) +" AltTrgsDN:"+LISTTOSTRING(AltTrgsDN) ). 
          log2file("        AGLTrgsUP:"+LISTTOSTRING(AGLTrgsUP) +" AGLTrgsDN:"+LISTTOSTRING(AGLTrgsDN) ). 
          log2file("        ECTrgsUP:"+LISTTOSTRING(ECTrgsUP) +" ECTrgsDN:"+LISTTOSTRING(ECTrgsDN) ). 
          log2file("        RSCTrgsUP:"+LISTTOSTRING(RSCTrgsUP) +" RSCTrgsDN:"+LISTTOSTRING(RSCTrgsDN) ). 
          log2file("        ThrtTrgsUP:"+LISTTOSTRING(ThrtTrgsUP) +" ThrtTrgsDN:"+LISTTOSTRING(ThrtTrgsDN) ).
          log2file("        PresTrgsUP:"+LISTTOSTRING(PresTrgsUP) +" PresTrgsDN:"+LISTTOSTRING(PresTrgsDN) ).
          log2file("        SunTrgsUP:"+LISTTOSTRING(SunTrgsUP)  +" SunTrgsDN:"+LISTTOSTRING(SunTrgsDN)  ).
          log2file("        TempTrgsUP:"+LISTTOSTRING(TempTrgsUP) +" TempTrgsDN:"+LISTTOSTRING(TempTrgsDN) ). 
          log2file("        GravTrgsUP:"+LISTTOSTRING(GravTrgsUP) +" GravTrgsDN:"+LISTTOSTRING(GravTrgsDN) ). 
          log2file("        AccTrgsUP:"+LISTTOSTRING(AccTrgsUP)  +" AccTrgsDN:"+LISTTOSTRING(AccTrgsDN)  ). 
          log2file("        TWRTrgsUP:"+LISTTOSTRING(TWRTrgsUP)  +" TWRTrgsDN:"+LISTTOSTRING(TWRTrgsDN)  ). 
          log2file("        StsTrgsUP:"+LISTTOSTRING(StsTrgsUP)  +" StsTrgsDN:"+LISTTOSTRING(StsTrgsDN)  ). 
          log2file("        FuelTrgsUP:"+LISTTOSTRING(FuelTrgsUP) +" FuelTrgsDN:"+LISTTOSTRING(FuelTrgsDN) ).
        }
}
function minmax {
  local parameter listL, MD IS "".

  local Lmin to 9999999.
  local Lmax to 0.
  LOCAL FND TO 0.
  for i in range (1,itemlist[0]+1){ 
    LOCAL ML TO 0.
    for item in listL[I]{
      if item<> 0 {
        IF dbglog > 2 {
          IF ML = 0 log2file("           MIN MAX:"+MD).
          log2file("              "+ITEMLIST[I]+":"+ITEM).
          SET ML TO 1.
          SET FND TO 1.
        }
        if item < Lmin set Lmin to item.
        if item > Lmax set Lmax to item.
      }
    }
  }
  if lmin = 9999999 set lmin to 0.
  if lmin = LMAX set lmin to 0. 
  IF dbglog > 2 AND FND > 0 log2file("                  MIN:MAX "+Lmin+":"+Lmax).
  return list(Lmin, Lmax).  
}
function GetSTSList {
  parameter listL.
  LOCAL LST IS LIST(0).
  for i in range (1,itemlist[0]+1){for item in listL[I]{if item<> 0 {if NOT LST:CONTAINS(ITEM) LST:ADD(item).}}}
  return lst.  
}
function listfix{ //doesnt work
  local parameter lstin.
          for i in range (1,itemlist[0]+1){
            for T in range (1,prtTAGList[I][0]+1){if t = prtTAGList[I][0]+1 break.
                print i+"-"+t+"-"+p.
                local zzz to lstin[i][t]:tostring.
                set lstin[i][t] to zzz:tonumber.
              }
          }
return lstin:copy.
}






function loadAutoSettings{
  if dbglog > 0 log2file("    LOAD AUTO SETTINGS").
  parameter opt is 0.
  local loadp to 22.  if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
    local refreshTimer to TIME:seconds.
    local isdone to 0.
          local line to 2.
          local rchhk to 0.
    if loadbkp = 2 {IF file_exists(autofileBAK) set LISTIN TO READJSON(SubDirSV + autofileBAK). set line to 1.}
      global AutoDspListTMP to  listin[0]:copy.
      global  autovallistTMP to listin[1]:copy.
      global  itemlistTMP to    listin[2]:copy.
      global  prttaglistTMP to  listin[3]:copy.
      global  prtlistTMP to     listin[4]:copy.
      global autoRstListTMP to  listin[5]:copy.
      global AutoRscListTMP to  listin[6]:copy.
      global AutoTRGListTMP to  listin[7]:copy.
          for i in range (1,itemlistTMP[0]+1){
            for T in range (1,prtTAGListTMP[I][0]+1){if t = prtTAGListTMP[I][0]+1 break.
              local tmplist to ship:partstagged(prttaglistTMP[I][T]).
                FOR P IN RANGE (1,prtListTMP[I][T][0]+1){if p = prtListTMP[I][T][0]+1 break.
                  local tmplist2 to tmplist:copy.
                  local i1 to itemlist:find(itemlistTMP[I]).
                  if i1 > 0 {
                  local t1 to prttagList[I1]:find(prttagListTMP[I][T]).
                      if t1 > 0 {
                        if prtlist[I1][T1][0]+1 > p{
                          if prtlisttmp[I][T][P]:tostring = core:part:tostring and prtlist[I1][T1][P]:tostring <> core:part:tostring 
                            set prtlisttmp[I][T][P] to prtlist[I1][T1][P].
                        }
                      }
                  }
                  if tmplist2:tostring:contains(prtlisttmp[I][T][P]:tostring){
                    for itm in tmplist2{
                      if itm:tostring = prtlisttmp[I][T][P]:tostring{
                        set prtlisttmp[I][T][P] to itm.
                        tmplist:remove(tmplist:find(itm)).
                        break.
                      }
                    }
                  }
                }
              }
          }
          local lstoff to 0.
      if itemlistTMP[0] > itemlist[0] set lstoff to 1. 
      else if itemlistTMP[0] < itemlist[0] set lstoff to 2.
      if lstoff = 0 {
        if dbglog > 2 log2file("      ITEMLIST LENGTH:"+itemlist[0]+"="+itemlisttmp[0]).
        for i2 in range(1,itemlist[0]+1){
          if prtTagListTMP[i2][0] > prtTagList[i2][0] set lstoff to 1. 
          else if prtTagList[i2][0] < prtTagListTMP[i2][0] set lstoff to 2.
          if lstoff = 0 {
            if dbglog > 2 log2file("         TAGLIST LENGTH:"+i2+":"+prtTagList[i2][0]+"="+prtTagListTMP[i2][0]).
            for t2 in range(1,prtTagList[i2][0]+1){
              if dbglog > 2 log2file("                   TAG:"+T2+":"+prtTagList[i2][T2]+"="+prtTagListTMP[i2][T2]).
              if prtlistTMP[i2][t2][0] > prtlist[i2][t2][0] set lstoff to 1. 
              else if prtlistTMP[i2][t2][0] < prtlist[i2][t2][0] set lstoff to 2.
              if lstoff <> 0 break. else if dbglog > 2 log2file("         PARTLIST LENGTH:"+t2+":"+prtlist[i2][t2][0]+"="+prtlistTMP[i2][t2][0]).
            }
          }
          if lstoff <> 0 break.
        }
      }

      if lstoff > 0 evenlist(lstoff).
      if loadattempts > 0 set autovallisttmp[0][0][0] to autovallisttmp[0][0][0]+loadattempts.
      local imin to min(itemlistTMP[0], itemlist[0]).
      local tmin is min(prttaglistTMP[1][0], prttaglist[1][0]).
      local pmin is min(prtlistTMP[1][1][0], prtlist[1][1][0]).
      local ioff to 0. local toff to 0. local poff to 0. 
      if imin < max(itemlistTMP[0], itemlist[0]) set ioff to 1.
      if tmin < max(prttaglistTMP[1][0], prttaglist[1][0]) set toff to 1.
      if pmin < max(prtlistTMP[1][1][0], prtlist[1][1][0]) set poff to 1.
      //for l in range(1,3){
        if LOADBKP<>2{
        for i in range(1,imin){
          if opt = 1 set loadp to loadp+1. print "." at (loadp,LNstp-1).
          if itemlist[I] <> itemlistTMP[I]{set ioff to ioff+1. set ioff to ioff+1.}
          for t in range(1,min(prttaglistTMP[I][0], prttaglist[I][0])+1){
            if t < tmin  if prttaglist[I][T] <> prttaglistTMP[I][T]{set toff to toff+1. set toff to ioff+1.}
            for p in range(1,min(prtlistTMP[I][T][0], prtlist[I][T][0])+1){
              if p < pmin if prtlist[I][T][P] <> prtlistTMP[I][T][P]{if NOT prtlist[I][T][P]:hasmodule("ModuleCommand"){ set poff to poff+1. set poff to ioff+1.}}
            }
          }
        }
      //}
        }else {set ioff to 0. set toff to 0. set poff to 0.}
      IF autovallistTMP[0][0][0] > 1000 and ioff = 0 and toff = 0 and poff = 0 {set line to LNstp. set LNstp to LNstp+1. button7().}else{DESKTOP(). 
        if ioff = 0 {print "itemlist match" at (1,line). set line to line+1.}else{print "itemlist mismatch:"+ioff+" mismatched items" at (1,line).set line to line+1.}
        if toff = 0 {print "Taglist match"  at (1,line). set line to line+1.}else{print  "Taglist mismatch:"+toff+" mismatched items" at (1,line).set line to line+1.}
        if poff = 0 {print "Partlist match" at (1,line). set line to line+1.}else{print "Partlist mismatch:"+poff+" mismatched items" at (1,line).set line to line+1.}
        print "load settings?" at (1,line). set line to line+1.
        PRINT "|    YES   |    NO    | AUTO LOAD|" at (0,18).
        if loadbkp <> 2 IF file_exists(autofileBAK) PRINT "| lOAD BKP  |" AT (33,18).
        }     
      //#region buttons 
      set v0:wave to "sawtooth".
      function button7{ALOAD(rchhk,lstoff).
       SET isDone to 1. SET LOADBKP TO 0.  set refreshTimer to TIME:seconds+1000000.
      }buttons:setdelegate(7,button7@).
      
      function button8{
        set refreshTimer to TIME:seconds+1000000.
        print GetColor("Settings discarded.","ORN",0)at (1,line).
        set line to line+1.
         IF file_exists(autofile) DELETEPATH(SubDirSV +autofile). 
         SET isDone to 1.
         SET LOADBKP TO 0.
        }buttons:setdelegate(8,button8@).
      function button9{
         set refreshTimer to TIME:seconds+1000000.
        print "Settings will be loaded automatically on match."at (1,line). 
        set autovallisttmp[0][0][0] to 1001. set line to line+1. set LNstp to line+1. ALOAD(rchhk,lstoff).
        SET isDone to 1.
        SET LOADBKP TO 0.
        }buttons:setdelegate(9,button9@).
      function button10{
        SET LOADBKP TO 2.
        SET isDone to 1.
        set rchhk to 1.
        set refreshTimer to TIME:seconds+1000000.
        }buttons:setdelegate(10,button10@).
      //#endregion buttons
      local tmebk to 0.
      until isDone > 0 {
        local tme to ROUND((10- (TIME:SECONDS - refreshTimer)),0).
        if tmebk <> tme {PRINTLINE("Auto Selecting Yes in " + tme + " SECONDS      ",0,17). set tmebk to tme.}
        if tme < 1 {button7().}
      }




      
        function evenlist{
          LOCAL PARAMETER OPIN.
          if dbglog > 1 log2file("    evenlist:"+opin).
          local itl to list(0).
          IF OPIN = 1{
                for k in range (1,itemlistTMP[0]+1){
                  if not prtListTMP[k][0][0]:tostring:contains("/") set prtListTMP[k][0][0] to "temp"+"/"+0.
                  IF DBGLOG > 2 log2file(prtListTMP[k][0][0]).
                  itl:add(prtListTMP[k][0][0]:split("/")[0]).
                }
            for i in range (1,itemlistTMP[0]+1){
              if i < itemlistTMP[0]+1 {
                //if i = itemlistTMP[0]+1 break.
                if prtList:length = i prtList:add(list(list("temp"+"/"+0))).
                if prtList[I][0][0]:tostring <> prtlistTMP[I][0][0]:tostring or prtList:length = i{
                  local pl0 to prtList[I][0][0]:split("/").
                  local plT to prtListTMP[I][0][0]:split("/").
                  IF DBGLOG > 2 log2file("   "+prtList[I][0][0]+":"+prtListTMP[I][0][0]).
                  if plt[0] <> pl0[0] {
                    if pl0[1]:tonumber < itl:find(pl0[0]) or itl:find(pl0[0]) = -1{
                      local ADout to list(list(0)).
                      local AVout to list(list(0)).
                      local itmout to "na".
                      local tgout to list(1,"NONE").
                      local ptout to list(list(0)).
                      local arout to list(list(0)).
                      local acout to list(list(0)).
                      local ac0ut to list(list(0)).
                      local atout to list(list(0)).
                      local a0out to list(list(0)).
                      if itl:find(pl0[0])-1 = pl0[1]:tonumber {
                        set ADout to AutoDspListTMP[I].
                        set AVout to autovallistTMP[I].
                        set itmout to itemlistTMP[I].
                        set tgout to prttaglistTMP[I].
                        set ptout to prtlistTMP[I].
                        set arout to autoRstListTMP[I].
                        set acout to AutoRscListTMP[I].
                        set ac0ut to AutoRscListTMP[0][I].
                        set atout to AutoTRGListTMP[I].
                        set a0out to AutoTRGListTMP[0][I].
                        }
                      AutoDspList:insert(i,ADout:copy) .
                      autovallist:insert(i,AVout:copy) .
                      itemlist:insert(i,itmout).
                      prttaglist:insert(i,tgout:copy).
                      prtlist:insert(i,ptout:copy).
                      autoRstList:insert(i,arout:copy).
                      AutoRscList:insert(i,acout:copy).
                      AutoRscList[0]:insert(i,ac0ut:copy).
                      AutoTRGList:insert(i,atout:copy). 
                      AutoTRGList[0]:insert(i,a0out:copy). 
                      if plt[1]:tonumber = i {
                        set prtList[I] to prtListtmp[I].
                        set prtList[I][0][0] to plt[0]+"/"+plt[1].
                        tagfix(plt[0],plt[1]).
                      }
                    }

                  }else{
                      if plt[1]:tonumber = i {
                        set prtList[I] to prtListtmp[I].
                        set AutoDspList[I] to AutoDspListtmp[I].
                        set autovallist[I] to autovallisttmp[I].
                        set itemlist[I] to itemlisttmp[I].
                        set prttaglist[I] to prttaglisttmp[I].
                        set prtlist[I] to prtlisttmp[I].
                        set autoRstList[I] to autoRstListtmp[I].
                        set AutoRscList[I] to AutoRscListtmp[I].
                        set AutoRscList[0][I] to AutoRscListtmp[0][I].
                        set AutoTRGList[I] to AutoTRGListtmp[I].
                        set AutoTRGList[0][I] to AutoTRGListtmp[0][I].
                        set prtList[I][0][0] to plt[0]+"/"+plt[1].
                        tagfix(plt[0],plt[1]).
                      }
                  }
                  wait 0.25.
                }
              }
            }
          }
          IF OPIN = 2{
                for k in range (1,itemlist[0]+1){
                  if not prtList[k][0][0]:tostring:contains("/") set prtList[k][0][0] to "temp"+"/"+0.
                  log2file(prtList[k][0][0]).
                  itl:add(prtList[k][0][0]:split("/")[0]).
                }
            for i in range (1,itemlist[0]+1){
              if i < itemlist[0]+1 {
                //if i = itemlist[0]+1 break.
                if prtListTMP:length = i prtListTMP:add(list(list("temp"+"/"+0))).
                if prtListTMP[I][0][0]:tostring <> prtlist[I][0][0]:tostring or prtListTMP:length = i{
                  local plt to prtListTMP[I][0][0]:split("/").
                  local pl0 to prtList[I][0][0]:split("/").
                  IF DBGLOG > 2 log2file("   "+prtList[I][0][0]+":"+prtListTMP[I][0][0]).
                  if pl0[0] <> plt[0] {
                    if plt[1]:tonumber < itl:find(plt[0]) or itl:find(plt[0]) = -1{
                      local ADout to list(list(0)).
                      local AVout to list(list(0)).
                      local itmout to "na".
                      local tgout to list(1,"NONE").
                      local ptout to list(list(0)).
                      local arout to list(list(0)).
                      local acout to list(list(0)).
                      local ac0ut to list(list(0)).
                      local atout to list(list(0)).
                      local a0out to list(list(0)).
                      if itl:find(plt[0])-1 = plt[1]:tonumber {
                        set ADout to AutoDspList[I].
                        set AVout to autovallist[I].
                        set itmout to itemlist[I].
                        set tgout to prttaglist[I].
                        set ptout to prtlist[I].
                        set arout to autoRstList[I].
                        set acout to AutoRscList[I].
                        set ac0ut to AutoRscList[0][I].
                        set atout to AutoTRGList[I].
                        set a0out to AutoTRGList[0][I].
                         }
                      AutoDspListTMP:insert(i,ADout:copy) .
                      autovallistTMP:insert(i,AVout:copy) .
                      itemlistTMP:insert(i,itmout).
                      prttaglistTMP:insert(i,tgout:copy).
                      prtListTMP:insert(i,ptout:copy).
                      autoRstListTMP:insert(i,arout:copy) .
                      AutoRscListTMP:insert(i,acout:copy) .
                      AutoRscListTMP[0]:insert(i,ac0ut:copy) .
                      AutoTRGListTMP:insert(i,atout:copy) . 
                      AutoTRGListTMP[0]:insert(i,a0out:copy).
                      if pl0[1]:tonumber = i {
                        set prtListTMP[I] to prtList[I].
                        set prtListTMP[I][0][0] to pl0[0]+"/"+pl0[1].
                        tagfix(pl0[0],pl0[1]).
                      }
                    }

                  }else{
                      if pl0[1]:tonumber = i {
                        set prtListTMP[I] to prtList[I].
                        set AutoDspListTMP[I] to AutoDspList[I].
                        set autovallistTMP[I] to autovallist[I].
                        set itemlistTMP[I] to itemlist[I].
                        set prttaglistTMP[I] to prttaglist[I].
                        set prtListTMP[I] to prtlist[I].
                        set autoRstListTMP[I] to autoRstList[I].
                        set AutoRscListTMP[I] to AutoRscList[I].
                        set AutoRscListTMP[I][0] to AutoRscList[I][0].
                        set AutoTRGListTMP[I] to AutoTRGList[I].
                        set AutoTRGListTMP[0][I] to AutoTRGList[0][I].
                        set prtListTMP[I][0][0] to pl0[0]+"/"+pl0[1].
                        tagfix(pl0[0],pl0[1]).
                      }
                  }
                  wait 0.25.
                }
              }
            }
          }
          set itemlist[0] to itemlist:length-1.
          //if itemlistTMP:length > itemlist:length set itemlistTMP to itemlistTMP:SUBLIST(0,itemlist:length).
          set itemlistTMP[0] to itemlistTMP:length-1.
          set LFX to 1.
          //set rchhk to 1.
          //partcheck().
        }
        function tagfix{
          local parameter tagin, namein.
          if namein:typename="string" set namein to namein:tonumber.
          IF dbglog > 2 log2file("        TagFix:"+TAGIN+"-"+namein).
          if tagin = "lighttag" set lighttag to namein.
          if tagin = "AGTag" set AGTag to namein.
          if tagin = "FlyTag" set FlyTag to namein.
          if tagin = "CntrlTag" set CntrlTag to namein.
          if tagin = "engtag" set engtag to namein.
          if tagin = "dcptag" set dcptag to namein.
          if tagin = "geartag" set geartag to namein.
          if tagin = "chutetag" set chutetag to namein.
          if tagin = "ladtag" set ladtag to namein.
          if tagin = "baytag" set baytag to namein.
          if tagin = "Docktag" set Docktag to namein.
          if tagin = "RWtag" set RWtag to namein.
          if tagin = "slrtag" set slrtag to namein.
          if tagin = "RCStag" set RCStag to namein.
          if tagin = "drilltag" set drilltag to namein.
          if tagin = "radtag" set radtag to namein.
          if tagin = "scitag" set scitag to namein.
          if tagin = "anttag" set anttag to namein.
          if tagin = "FWtag" set FWtag to namein.
          if tagin = "ISRUTag" set ISRUTag to namein.
          if tagin = "Labtag" set Labtag to namein.
          if tagin = "RBTTag" set RBTTag to namein.
          //MKS MOD
          if tagin = "MksDrlTag" set MksDrlTag to namein.
          if tagin = "PWRTag" set PWRTag to namein.
          if tagin = "DEPOTag" set DEPOTag to namein.
          if tagin = "habTag" set habTag to namein.
          if tagin = "CnstTag" set CnstTag to namein.
          if tagin = "DcnstTag" set DcnstTag to namein.
          if tagin = "ACDTag" set ACDTag to namein.
          //OTHER MODS
          if tagin = "CapTag" set CapTag to namein.
          //BDA MOD (KEEP LAST TO MAAKE WMGR QUICKLY ACCESSABLE)
        // if tagin = "Missiletag" set Missiletag to namein.
        // if tagin = "Guntag" set Guntag to namein.
          if tagin = "BDPtag" set BDPtag to namein.
          if tagin = "CMtag" set CMtag to namein.
          if tagin = "Radartag" set Radartag to namein.
          if tagin = "FRNGtag" set FRNGtag to namein.
          if tagin = "WMGRtag" set WMGRtag to namein.
        }
        FUNCTION ALOAD{
        local parameter rcheck is 0, loff is 0.
        if dbglog > 1 log2file("      ALOAD:Recheck="+rcheck).
        SET autovallist TO autovallistTMP:copy. SET isDone to 1.
        SET AutoDspList TO AutoDspListTMP:copy. 
        SET autoRstList TO autoRstListTMP:copy.
        SET AutoRscList TO AutoRscListTMP:copy.
        SET AutoTRGList TO AutoTRGListTMP:copy.
        if loff <> 0{
          SET itemlist TO itemlistTMP:copy.
          SET prtlist TO prtlistTMP:copy.
          SET prttaglist TO prttaglistTMP:copy.
        }
        if AutoDspList[0]:length = 1 addlist().
        set HdngSet to autovallist[0][0][1].
        //local prb to 0.
        //if HdngSet[3]= 0 {set prb to 1.}else{if HdngSet[3]:length < 10 set prb to 1.}// can be removed after testing
        //if  HdngSet:LENGTH < 4 or prb= 1{// can be removed after testing
        //  set HdngSet to list(list(9,0  ,0   ,0   ,0   ,0      ,0   ,60 ,40  ,60 ), //set
        //                      list(9,359, 180, 180,5000,1000000, 500,180,5000,180), //max
        //                      list(9,0  ,-180,-180,0   ,0      ,-500,0  ,0   ,0  ), //min
        //                      list(9,1  ,1   ,1   ,0   ,0      ,0   ,1  ,0   ,0  )). //on/off
        //}
        SET HEIGHT TO autovallist[0][0][2].
        set refreshRateSlow to autovallist[0][0][4][0].
        set refreshRateFast to autovallist[0][0][4][1].
        if debug = 0 set debug to autovallist[0][0][4][2].
        if dbglog = 0 set dbglog to autovallist[0][0][4][3]. 
        SaveAutoSettings().
        if rcheck = 1 LoadShip(0).
      }
    }
//#endregion
function HudFuction{
  initialset().
  HudFuctionMain().
  function initialset{
    global DispInfo to 0.
    global HDXT TO "     ".
    global ploc to 12.
    global pwdt to 14.
    global pwdt2 to 28.
    global pwdt3 to 14.
    global ploc2 to ploc+1+pwdt. //ploc+14
    global ploc3 to ploc2+1+pwdt2. //ploc+44.
    global axsel to 1.
    global fo to 0.
    global foblink to 0.
    global Raxsel to 1.
    global FList to LIST(3,10,15,25).
    global FSel to 1.
    if IsPayload[0] = 1 {set RunAuto to 0. SET refreshRateSlow TO 10. set refreshRateFast to 10. set RFSBAak to refreshRateSlow.}
    if SHIP:status = "PRELAUNCH" set RunAuto to 2.
    global runautobak to RunAuto.
    global CSaxis TO LIST(3,"pitch","yaw","roll").
    global APaxis TO LIST(9,"pitch","yaw","roll","speed","alt","V-SPD","Pitch Lim","Roll Lim","AOA Lim").    
    global RCSaxis TO LIST(6,"pitch","yaw","roll","port/stbd","dorsal/ventral","fore/aft").
    global HudRstMdLst to list(4," DISABLE  ","CHANGE DIR"," RESET UP "," RESET DN ").
    global ShipStatPREV to " ".
    global ShipStatPREV2 to "NONE".
    global FlState to " ".
    global RscSelection to 0.
    global Trim to 0.
    global TrimMax to 15.
    global anttrgsel to 1.
    global scipart to 1.
    Global EnabSel to 1.
    Global ModeSel to 1.
    global ConvRSC to 1.
    global BayLst to list(0).
    global BayTrg to list(0).
    global BaySel to 1.
    global SciDsp to "".
    if refreshRateFast < 1 set refreshRateFast to 1.
    if refreshRateSlow < 1 set refreshRateSlow to 1.
    global MtrPrtSel to list(0,0,0,0,0,0,0,0,0).
    global enghud to list(1,2,3).
    global AUTOHUD TO LIST(0,1,"  OVER ").
    global EmptyHud to "          ".
    global fuelmon to 0.
    global hudstart to 17.
    global RowSel to 1.
    global HSel to list(0).
    global HUDOP TO 1.
    global HUDOPPREV TO 1.
    global AutoAdjByLst to list(7,1,5,10,100,1000,10000,100000).
    global AUTOHUDBK TO AUTOHUD.
    global HudOptsL to list(0).
    global HudOptsR to list(0). 
    HudOptsL:add(list(0,"PREV    "   ,"PREV    "   ,"THRUST  "   ,"        "   ,"        "   ,"PREV    "   ,"PREV    "   ,"PREV    "   ,"PREV    "   ,"        "   )).
    HudOptsL:add(list(0,"GROUP       ","PART      ","LIM DN     ","           ","AUTO DIR   ","ACTION     ","TARGET     ","AXIS       ","WEAPON     ","LIM DN  "  )).
    HudOptsL:add(list(0,"NEXT       ","NEXT       ","THRUST     ","           ","AUTO ADJ BY","NEXT       ","NEXT       ","NEXT       ","NEXT       ","        ")).
    HudOptsL:add(list(0,"GROUP   "   ,"PART  "     ,"LIM UP "    ,"       "    ,"       "    ,"ACTION "    ,"TARGET "    ,"AXIS    "   ,"WEAPON  "   ,"LIM UP "    )).
    HudOptsL:add(list(0,"      "     ,"      "     ,"       "    ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"       "    )).
    HudOptsL:add(list(0,"      "     ,"      "     ,"       "    ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"       "    )).
    HudOptsL:add(list(0,"      "     ,"      "     ,"       "    ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"       "    )).
    HudOptsL:add(list(0,"      "     ,"      "     ,"       "    ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"      "     ,"       "    )).
    HudOptsR:add(list(0,"       LIST","       LIST","       LIST","       LIST","       AUTO","       LIST","       LIST","       LIST","       LIST","       LIST")).
    HudOptsR:add(list(0,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   ,  "   UP "   )).
    HudOptsR:add(list(0,"    LIST"   ,"    LIST"   ,"    LIST"   ,"    LIST"   ,"    AUTO"   ,"    LIST"   ,"    LIST"   ,"    LIST"   ,"    LIST"   ,"    LIST"   )).
    HudOptsR:add(list(0,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   ,"    DOWN"   )).
    HudOptsR:add("AUTO").
    HudOptsR:add("      ").
    HudOptsR:add(list(0,"   SET AUTO"    ,"   SET AUTO"    ,"   SET AUTO"    ,"   SET AUTO"    ,"     CANCEL"     ,"   SET AUTO"    ,"           "    ,"           "    ,"           "    ,"           "    )).
    HudOptsR:add(list(0,"    "       ,"    "       ,"    "       ,"    "       ,"      "     ,"EXP "       ,"    "       ,"    "       ,"    "       ,"    "       )).
    FOR i IN RANGE(1, prtTagList[engtag][0]+1) { 
      if prtTagList[engtag][I]:CONTAINS("Main") {enghud:remove(i-1). enghud:insert(0,i).}
    }
    FOR I IN RANGE(1, 10) {
       hsel:add(list(0,1,1,1)).
    }
    FOR i IN RANGE(0, 10) {
      hudopts:add(list(" "," "," "," ")).
    }
    FOR i IN RANGE(2, 10,2) {
      set HudOpts[I][1] to itemlist.
      set HudOpts[I][2] to prttaglist[1].
      set HSEL[I][1] to 1.
    }
    set eng to list(EMPTYHUD,EMPTYHUD,EMPTYHUD,EMPTYHUD,EMPTYHUD,EMPTYHUD,EMPTYHUD,EMPTYHUD).
    set PrvITM to EmptyHud.
    set ItmTrg to EmptyHud.
    set nxtITM to EmptyHud.
    set BTHD10 to EmptyHud.
    set BTHD11 to EmptyHud.
    set BTHD12 to EmptyHud.
    global trglst to getRTVesselTargets().
    global ItemNumPrv to 0.
    global tagNumPrv to 0.
    if loadattempts < 3 {
        if AutoDspList[0][0][0] > 0 set hsel[2][1] to AutoDspList[0][0][0].
        if AutoDspList[0][0][1] > 0 set hsel[2][2] to AutoDspList[0][0][1].
    }
      if hsel[2][2] >  HudOpts[2][2]:length set hsel[2][2] to 1.
      if hsel[2][1] >  HudOpts[2][1]:length set hsel[2][1] to 1.
      global checktime to time:seconds.
  }
  function HudFuctionMain{
    //#region update screen
    CLEARSCREEN.
    local isDone to 0.
    local refreshTimer to TIME:SECONDS.
    local refreshTimer2 to TIME:SECONDS.
    local buttonRefresh to 1.
    UPDATEHUDOPTS().
    set tagnumprv to 0.
    set ItemNumPrv to 0.
    updatehudFast().
    updatehudSlow().
    set RowSel to 2.
    UPDATEHUDOPTS().
   function updatehudSlow {
    IF dbglog > 2 log2file("UPDATEHUDSLOW").
      if hudop = 5{
        local enb to "".
        printline("",0,1).
        if AutoRscList[0][EnabSel]       = 1 set enb  to " VISIBLE  ". else set enb  to "SKIP OVER ".  
        if AutoValList[0][0][3][modesel] = 2 set enb2 to "SKIP OVER ".
        if AutoValList[0][0][3][modesel] = 1 set enb2 to " VISIBLE  ".
        if AutoValList[0][0][3][modesel] = 3 set enb2 to "SNSR ONLY ".
        set enb3 to MODElong[modesel].
        if modesel = 1 set enb2 to "          ".
        set eng[0] to EMPTYHUD. 
        set eng[1] to "AUTO MODE ".
        set eng[2] to " MODE VIS ".
        set eng[3] to "   MODE   ". 
        if h5mode <> 1 set eng[4] to "  DELAY   ". else set eng[4] to "**DELAY** ".
        set eng[5] to "VISIBILITY".
        set eng[7] to "   ITEM   ".
        local dctprint to "  NORMAL  ".
        if dctnmode > 0 {
          set dctprint to "WAIT 4 OTH".
          if dctnmode = 2 set dctprint to "LOCK 2 OTH".
          set eng[2]   to "   ITEM   ".
          set eng[3]   to "    TAG   ".
          set enb2 to ItemListHUD[HdItm].
          set enb3 to Prttaglist[HdItm][hdtag].
          set enb3 to makehud(enb3).
        }
        print " |"+dctprint+"|"+enb2+"|"+enb3+"|" at (0,1).
        print "|"+enb+"|"+HudOpts[2][1][EnabSel] at (45,1).
        print curdelay at (39,1).}
      else{
      set eng[0] to EmptyHud.
      set eng[1] to EmptyHud.
      set eng[2] to EmptyHud.
      set eng[3] to EmptyHud.
      set eng[4] to EmptyHud.
      set eng[5] to EmptyHud.
      set eng[7] to EmptyHud.
        for i in range(1,prtTagList[engtag][0]+1){
          LOCAL TG TO prtTagList[engtag][enghud[i-1]].
          LOCAL PT TO prtlist[engtag][enghud[i-1]][1].
          local j to i*2.
          set engsfx to " ENG:"+i.
          if TG:CONTAINS("Main")     set engsfx to " MAIN ". 
          if TG:CONTAINS("Scramjet") set engsfx to "SCRMJT". 
          if TG:CONTAINS("Booster")  set engsfx to "BOOSTR". 
          if TG:CONTAINS("Nuclear" ) set engsfx to "NUKENG".
          local engact to 0.

          if pt:hassuffix("ignition"){if pt:ignition = false set engact to 2. else set engact to 1.}
          else{
            local lon to list("on", "activate").
            local loff to list("off","shutdown").
            local Elst to engModAlt.
            if Pt:hassuffix("modes") if Pt:modes:length > 1 if not Pt:primarymode set Elst to list("MultiModeEngine").
            set engact to getactions("OnOff",Elst,engtag, enghud[i-1],1,1,lon,loff).
          }
          IF PT <> CORE:part {
          if engact = 1{SET eng[j-1] TO engsfx+" ON ".}ELSE{if engact = 2{SET eng[j-1] TO engsfx+" OFF".}else{SET eng[j-1] TO EmptyHud.}}
          IF PT:hasmodule("MultiModeEngine"){ 
            local Md to PT:getmodule("MultiModeEngine"):getfield("mode").
            if md = "Wet" set md to " AFTERBRN ". else if md = "ClosedCycle" set md to "CLOSED CYC". 
            if Pt:hassuffix("modes") if Pt:modes:length > 1 if PT:primarymode {SET eng[J] TO "  NORMAL  ".} ELSE  {SET eng[J] TO md.}
          }else{SET eng[J] TO EmptyHud.}
          }else{SET eng[j] TO EmptyHud. SET eng[j-1] TO EmptyHud.}
        }
      IF INTAKES {SET Eng[7] TO "INTAKES ON".} ELSE  {SET Eng[7] TO "INTAKE OFF".} 
    }
      PRINT "|"+Eng[1]+"|"+Eng[2]+"|"+Eng[3]+"|"+Eng[4]+"|"+Eng[5]+"|"+Eng[7]+"|LEAVE PRGM|" at (0,0).
      if hudop <> 5 {if FuelUpdRate = "Slow" updatemeter().}
    }
   function updatehudFast {
      if hudop <> 5{
        set HUDTOP to GetHudTop().
        ListToSpace(HUDTOP[1],ploc2,2).
        ListToSpace(HUDTOP[0],ploc ,1).
        ListToSpace(HUDTOP[2],ploc3,2).
        IF forcerefresh > 0 {SET STPREV TO "0". SET BOTPREV TO "00".}
        LOCAL STPRINT TO " "+HudOpts[1][1]+ HudOpts[1][2]+ HudOpts[1][3].
        IF STPREV <> STPRINT printline(STPRINT,0,hudstart-1).
        SET STPREV TO STPRINT.
        if GrpDspList3[FLYTAG][1] = 6 {
          LOCAL PR TO "                   ".
          IF FlState = "Flight" {SET  ss to "         SIDESLIP:"+round(bearing_between(ship,srfprograde,ship:facing),1). if colorprint = 1 {set pr to "    ".}}
          else{ set ss to "                ". if colorprint = 1 {set ss to "    ". set pr to "                ".}}
          PRINTLINE(pr+"HEADING:"+ ROUND(compass_and_pitch_for()[0],0)+"         PITCH:"  + ROUND(compass_and_pitch_for()[1],0)+"         ROLL:"   + ROUND(roll_for(),0)+ss,"WHT",13).
          set ln14 to 2.
        }
        if FuelUpdRate = "Fast" AND BtnActn = 0 updatemeter().
      }
      function ListToSpace{
        local parameter lin, loc, SKP IS 1.
        local st to 0.
        LOCAL SK IS 0.
        if hudop=5 set st to 1.
        for i in range(st,lin:length){
          PRINT lin[I] AT (loc,I+1). 
          if lin[I]:contains("            ") SET SK TO SK+1.
          IF SK = SKP break.
         }
      }
      function GetHudTop {
        set listout1 to list().
        set listout2 to list().
        set listout3 to list().
        local thrst is 0.
        list engines in eng_list.
        for engs in eng_list {
          if engs:flameout = false and engs:ignition = true {
            set thrst to thrst + engs:thrust.
          }
        }
        local gravity is ship:body:mu / (ship:altitude + ship:body:radius)^2.
        set twr to round(thrst / (ship:mass * gravity),2).
        set thrst to round(thrst, 0).
        listout1:add("|Thrust: "+thrst+"      ").
        listout1:add("|TWR: "+TWR+"      ").
        IF FlState <> "Land"{ 
          listout1:add( "|PER: "+formatTime(eta:periapsis)+"  ").
          listout1:add( "|APO: "+formatTime(ETA:apoapsis)+"  ").
        }
        IF steeringmanager:enabled = TRUE{
          IF HdngSet[3][4] > 0 and HdngSet[0][4] > 0{listout1:add("|SPDLOCK:"+HdngSet[0][4]+"("+round(SHIP:VELOCITY:SURFACE:MAG,0)+")"+glt(HdngSet[0][4],round(SHIP:VELOCITY:SURFACE:MAG,0))+"  ").}
          IF HdngSet[3][5] > 0 and HdngSet[0][5] > 0{listout1:add("|ALTLOCK:"+HdngSet[0][5]+"("+round(SHIP:ALTITUDE,0)+")"+glt(HdngSet[0][5],round(SHIP:ALTITUDE,0))+"  ").}
          IF HdngSet[3][6] > 0 and HdngSet[0][6] > 0{listout1:add("|VSPDLOK:"+HdngSet[0][6]+"("+round(SHIP:VERTICALSPEED,0)+")"+glt(HdngSet[0][6],round(SHIP:VERTICALSPEED,0))+"  ").}
        }
      //hudtop middle
       listout2:add(PADMID(SHIP:status,pwdt2)).
          if senselist[5] = 1{
            set biomecur to BSensor:getmodule("ModuleGPS" ):getfield("biome").
            If biomecur = "???" set biomecur to "UNKNOWN".
            listout2:add(PADMID(body:name+":"+BiomeCur,pwdt2)).
          }
      if body:atm:exists {
        set HdngSet[1][5] to body:atm:height.
        if FlState = "SpaceATM"  {listout2:add(PADMID("ATM HEIGHT:"+body:atm:height+" M",pwdt2)).} 
      }
      IF BRAKES = TRUE        listout2:add(PADMID("**BRAKE**",pwdt2)).
      if fo = 1{
        set foblink to foblink+1.
        if foblink = 1        {listout2:add(PADMID("FLAMEOUT!",pwdt2)).}else{listout2:add(PADMID("    ",pwdt2)).}
        if foblink = 2 set foblink to 0.
      }
      if Radartag > 0 {if prtlist[radartag][1][1]:hasmodule("ModuleRadar"){
          LOCAL rdrmod to GetMultiModule(prtlist[radartag][1][1],"lock","ModuleRadar")[1].
          if wordcheck(rdrmod[0],"current locks") = 1 and rdrmod[1] > 0{listout2:add(PADMID("**LOCK**",pwdt2)).}
      }}
      if steeringmanager:enabled = false {if sas = true listout2:add(PADMID("SAS:"+SASMODE,pwdt2)).
      else listout2:add(PADMID("SAS OFF",pwdt2)).}else{
        if HdngSet[3][4]+HdngSet[3][5]+HdngSet[3][6] = 0 listout2:add(PADMID("HEADING LOCK",pwdt2)). else listout2:add(PADMID("AUTOPILOT",pwdt2)).
        }
      //hudtop right
      listout3:add("|THR"+SetGauge(round(throttle*100,0), 1, pwdt3-1)).
      listout3:add("|ECG"+SetGauge(round(ship:electriccharge/ecmax*100,0), 1, pwdt3-1)).
      IF FlState = "Flight" listout3:add("|AOA: "+round(vertical_aoa(),1)+"   ").
      listout3:add("|Speed: "+round(SHIP:VELOCITY:SURFACE:MAG,0)+" M/S   ").
      LOCAL VSP TO round(SHIP:VERTICALSPEED  ,0).
      IF VSP > 0 SET VSP TO " "+VSP.
      IF STATUSFLY:CONTAINS(SHIP:status) listout3:add("|V-SPD:"+VSP+" M/S   ").
      listout3:add("|RDALT: "+round(ALT:RADAR-Height,0)+"  ").
      local lng to listout2:length+1.
      until listout2:length = 8 listout2:add("                          ").
      until listout3:length = 8 listout3:add("             ").
      until listout1:length = 8 listout1:add("             ").   
      return list(LISTOUT1,listout2,listout3).
        }
    }
   FUNCTION UPDATEHUDOPTS{
    IF dbglog > 2 log2file("UPDATEHUDOPTS").
        if ship:resources:tostring:contains("liquidfuel"){if ROUND(ship:resources[RscNum["liquidfuel"]]:amount/ship:resources[RscNum["liquidfuel"]]:capacity*100,0) < 10 SET forcerefresh TO 1.}
        IF ship:resources:tostring:contains("ELECTRICCHARGE"){if ROUND(ship:resources[RscNum["ELECTRICCHARGE"]]:amount/ship:resources[RscNum["ELECTRICCHARGE"]]:capacity*100,0) < 10 SET forcerefresh TO 1.}
      //#region set hud vars
      if buttonRefresh > 0 and forcerefresh = 0 set forcerefresh to 1.
      global itemnumcur to hsel[2][1].
      if itemnumcur <> ItemNumPrv and GrpDspList[itemnumcur][0] < itemlist[itemnumcur][0]+1 {set hsel[2][2] to GrpDspList[itemnumcur][0].}
      global TagNumCur to hsel[2][2].
      global partnumcur to hsel[2][3].
      local AutoCurMode to abs(AutoDspList[itemnumcur][TagNumCur]).
      set Curdelay to AutoTRGList[0][itemnumcur][TagNumCur].
      set rowval to 0.
      if RowSel=1 set rowval to 1.
      if itemnumcur <> ItemNumPrv or TagNumCur <> tagNumPrv or forcerefresh > 0 or (hudop <> 5 and HUDOPPREV = 5) {
        SET DCPRes TO 0.
      global alttag to 0.
      global currentPart to prtlist[itemnumcur][TagNumCur][partnumcur].
      global currentTag to  prttagList[itemnumcur][TagNumCur].
      global TagMax to HudOpts[2][2][0].
      global ItemMax to HudOpts[2][1][0]. 
        if hudop <> 5 AND HUDOPPREV = 5 { PRINTLINE("",0,1).  PRINTLINE("",0,14).  }
          set ItmTrg to grpopslist[itemnumcur][TagNumCur][GrpDspList[itemnumcur][TagNumCur]]. 
          set BTHD10 to grpopslist[itemnumcur][TagNumCur][GrpDspList2[itemnumcur][TagNumCur]]. 
          set BTHD11 to grpopslist[itemnumcur][TagNumCur][GrpDspList3[itemnumcur][TagNumCur]].
          set PrvITM TO CHECKOPT(ItemMax,itemnumcur,"-",6,1,1).
          set nxtITM TO CHECKOPT(ItemMax,itemnumcur,"+",6).
          IF ROWVAL = 0 {
            set PrvGRP TO CHECKOPT(Tagmax, TagNumCur,"-",7,1,1).
            set nxtGRP TO CHECKOPT(Tagmax, TagNumCur,"+",7).
          }else{
            set PrvGRP TO "                               ".
            set nxtGRP TO "                               ".
          }
        updatehudSlow().
      }
      if AutoCurMode = 14 set StsSelection to abs(AutoValList[itemnumcur][TagNumCur]).
      if StsSelection > STATUSOPTS[0] set StsSelection to STATUSOPTS[0]. 
      if StsSelection = 0 set StsSelection to 1.
      if hudop =5 and HUDOPPREV <> 5 {
        set EnabSel to itemnumcur.
        updatehudSlow().
      }
      if hudop < 6 {
        set HudOptsR[6] to AutoValList[itemnumcur][TagNumCur].
      }
      //#endregion
      //#region check missing part
      SET  missingpart to 0.
      if alltagged:length <> ship:ALLTAGGEDPARTS():length partcheck().
      local pl to prtList[itemnumcur][TagNumCur].
      set pl to pl:sublist(1, pl:length).
      if itemnumcur <> agtag and itemnumcur <> flytag{
        for p in pl{if not PrtListcur:contains(p) set MissingPart to MissingPart+1.}
      }
      //#endregion
      //#region run on change
      if missingpart < prtlist[itemnumcur][TagNumCur]:length-1{
        if itemnumcur <> ItemNumPrv or TagNumCur <> tagNumPrv or forcerefresh > 0 {
          if itemnumcur <> ItemNumPrv or TagNumCur <> tagNumPrv {
            set AutoSetAct to AutoTRGList[itemnumcur][TagNumCur].
            set MtrCur[0] to 0.
            set MtrCur[1] to 100.
            set MtrCur[2] to 5.
            if itemnumcur = rbttag set MtrCur[5] to 4.
            set autosetmode to autocurmode.
            set setdelay to curdelay.
            set AutoRstMode to autoRstList[itemnumcur][TagNumCur].
            if itemnumcur <> dcptag SET AutoValList[0][0][3][15] TO 0.
            SET LOADBKP TO 0. SET SAVEBKP TO 0. 
            if itemnumcur <> scitag PRINTLINE("",0,14). 
            LOCAL CLSKP TO 0.
            IF itemnumcur = flytag AND TagNumCur = 1 SET CLSKP TO 1.
            if GrpDspList3[FLYTAG][1] <> 6 and RunAuto = 1 and itemnumcur <> scitag and CLSKP = 0 OR forcerefresh > 0 PRINTLINE("",0,13).
            set botrow to bigempty2. 
            set BaySel to 1. 
            set fuelmon to 0. 
            if itemnumcur = FlyTag set AUTOHUD[1] to 1. 
            set axsel to 1. 
            set scipart to 1.
            if TagNumCur <> tagNumPrv {set GrpDspList[itemnumcur][0] to TagNumCur.}
            if AutoCurMode = 6 and autoRscList[hsel[2][1]][hsel[2][2]]:istype("string") set RscSelection to safekey(RscNum,autoRscList[hsel[2][1]][hsel[2][2]]). 
          }
          set rowT1 to "".
          set rowT2 to "".
          set statusdispnum to GrpDspList[itemnumcur][TagNumCur].
          if GrpDspList[itemnumcur][TagNumCur]= 1 set statusdispnum to 3.
          if GrpDspList[itemnumcur][TagNumCur]= 5 set statusdispnum to 7.
          set hudopts[1][1] to "".
          set hudopts[1][2] to "".
          set hudopts[1][3] to "".
          set DispInfo to 1.
          IF HUDOP <> 5{
          set ln14 to 0.
          if itemnumcur = lighttag {set DispInfo to 21.
          if TagNumCur = 1 {set BTHD11 to " SAVE BKP ". IF file_exists(autofileBAK) set BTHD10 to " LOAD BKP ". }
          }
          ELSE{
            
          if itemnumcur = AGtag {
            set DispInfo to 1.
           if TagNumCur = 11 AND THROTTLE > 0 {set GrpDspList[itemnumcur][TagNumCur] to 2. SET ItmTrg TO " TURN OFF ".}ELSE{ set GrpDspList[itemnumcur][TagNumCur] to 1. SET ItmTrg TO " TURN ON  ".}
            if TagNumCur = 1{
              if RunAuto = 1 set BTHD10 to " AUTO ON  ". ELSE IF RUNAUTO = 3 set BTHD10 to " AUTO OFF ". ELSE IF RunAuto = 2 OR RunAuto = 0 set BTHD10 to " AUTO WAIT".
              set bthd11 to " LIST AUTO".
            }
            if rowsel = 1{
              if tagNumcur = 2{
                set BTHD10 to "RFRSH HUD ". set BTHD11 to "RFRSH INFO".
                    PRINTLINE(" HUD refreshRate: "+refreshRateSlow+" SECONDS"+" INFO refreshRate: "+refreshRateFast+" SECONDS","WHT",14).  set ln14 to 1.
              }
              if tagNumcur = 10{
                if dbglog = 0 set BTHD10 to "  LOG OFF ". else if dbglog = 1 set BTHD10 to "  LOG ON  ".if dbglog = 2 set BTHD10 to "LOG VRBOSE".  if dbglog = 3 set BTHD10 to "LOG OVRKLL".
                if debug  = 0 set BTHD11 to " DEBUG OFF". else set BTHD11 to " DEBUG ON ".
                PRINTLINE(" ONLY ENABLE LOGGING IF YOU ARE HAVING A PROBLEM","RED",14).
                set ln14 to 1.
              }
              }
          }
          ELSE{
          if itemnumcur = Flytag {set DispInfo to 52.
            if TagNumCur = 1 {
              set ln14 to 2.
               if currentTag:contains("TARGET") set trglst to getRTVesselTargets(2).
              if rowval = 1 {
                set BTHD11 to "NEXT AXIS ". 
                if apsel = 3 set zop to 2. 
                if zop = 1 set BTHD10 to "ONE 2 CRNT". else set BTHD10 to "ONE 2 ZERO".
              if hdngset[3][axsel] = 1 set ItmTrg to " MODE ON  ". else set ItmTrg to " MODE OFF ".
              if apsel = 1 or axsel = 7 or axsel = 9 if AUTOHUD[1] > 3 set AUTOHUD[1] to 3.
               }
              else{set BTHD10 to "ALL 2 CRNT".}
            }
            else{set BTHD10 to emptyhud. set BTHD11 to emptyhud.}
          }
          ELSE{  
          if itemnumcur = ladtag   {}
          ELSE{
          if itemnumcur = geartag  {
            set DispInfo to 24.
            set rowT1 to ":".set rowT2 to "Steering:".
            if AutoBrake = 0 set BTHD10 to " BRAKE OFF". ELSE
            if AutoBrake = 1 set BTHD10 to " BRAKE ON ". ELSE
            if AutoBrake = 2 set BTHD10 to "AUTO BRAKE". 
            IF CurrentPart:hasmodule("ModuleWheelDeployment"){
              if rowval = 1 {
                set MtrCur[4] to 7. 
                set MtrCur[3] to 1.
                if getEvAct(pl[0],GearModLst[0][1],GearModLst[2][1],1) = False set ItmTrg to "SPRNG AUTO".else set ItmTrg to "SPRNG MAN ". 
                IF getEvAct(pl[0],GearModLst[0][7],GearModLst[2][7],1) = False set BTHD10 to "FRCTN AUTO".else set BTHD10 to "FRCTN MAN ".
                IF getEvAct(pl[0],GearModLst[0][3],GearModLst[2][3],1) = False set BTHD11 to "STEER AUTO".else set BTHD11 to "STEER MAN ". 
              }
            }ELSE{set BTHD11 to EmptyHud.}
          }
          ELSE{
          if itemnumcur = baytag   {if CurrentPart:hasmodule("ModuleAnimateGeneric") set DispInfo to 21.}
          ELSE{
          if itemnumcur = drilltag {set DispInfo to 41.}
          ELSE{
          if itemnumcur = chutetag {set DispInfo to 25. set rowT1 to ":".set rowT2 to "Safe to Deploy?:".
            if rowval = 1 {
              SET HDXT TO "OPTN". 
              set MtrCur[4] to 4. 
              set MtrCur[3] to 1.
            }
            FOR MD IN chuteModAlt{
              if CurrentPart:hasmodule(MD){
                if CurrentPart:getmodule(MD):hasfield(CHUTEModLst[0][MtrCur[5]]){
                  SET modulelist[itemnumcur][10] TO MD. 
                  set modulelistRPT[itemnumcur][10] to CHUTEModLst[0][MtrCur[5]].
                  BREAK.
                }
              }
            }
          }
          ELSE{
          if itemnumcur = radtag {set DispInfo to 32.  if wordcheck(getstatus(itemnumcur,TagNumCur,2,1),list("Idle","inactive")) = 1 set DispInfo to 22.}
          ELSE{
          if itemnumcur = anttag {set DispInfo to 21. 
          if rtech <> 0{
            set ln14 to 1.
            set trglst to getRTVesselTargets().
            if rowval=1{SET HDXT TO "TRGT".
              set PrvGRP TO CHECKOPT(trglst[0], anttrgsel,"-",trglst,1,1).
              set nxtGRP TO CHECKOPT(trglst[0], anttrgsel,"+",trglst).
            }
          }
               if GetActions(1,AntModAlt,itemnumcur, TagNumCur,1,3,list("extend","deploy","Activate"),list("retract","close")) = 0 set itmtrg to EmptyHud.
               if GetActions(1,AntModAlt,itemnumcur, TagNumCur,3,3,list("transmit")) = 0 set BTHD11 to EmptyHud.
              }
          ELSE{
          if itemnumcur = slrtag  {
            set DispInfo to 44.
            if pl[0]:hasmodule("KopernicusSolarPanel") SET modulelist[itemnumcur][1] TO "KopernicusSolarPanel". 
            if pl[0]:hasmodule("ModuleDeployableSolarPanel") SET modulelist[itemnumcur][1] TO "ModuleDeployableSolarPanel".
          }
          ELSE{
          if itemnumcur = Docktag {set DispInfo to 21.
          if getactions("OnOff",list("ModuleToggleCrossfeed"),itemnumcur, TagNumCur,1,1,list("enable"),list("disable")) = 0 set bthd11 to EmptyHud.
          if getactions("OnOff",AnimModAlt ,itemnumcur, TagNumCur,1,3,list("OPEN","TOGGLE","CLOSE")) = 0 set bthd10 to EmptyHud.
          if pl[0]:hassuffix("HASPARTNER") IF pl[0]:HASPARTNER = TRUE  set GrpDspList[itemnumcur][TagNumCur] to 2. ELSE set GrpDspList[itemnumcur][TagNumCur] to 1.
          if PL[0]:hassuffix("STATE") IF PL[0]:STATE ="DISABLED" set GrpDspList2[itemnumcur][TagNumCur] to 3.
          }
          ELSE{
          if itemnumcur = CntrlTag {
            set DispInfo to 62. local ans to "".
            if rowval=1{SET HDXT TO "AXIS".
              set PrvGRP TO CHECKOPT(CSaxis[0], axsel,"-",CSaxis,1,1).
              set nxtGRP TO CHECKOPT(CSaxis[0], axsel,"+",CSaxis).
            }      ///update to new methodf
            local brpc to "CYN".
            for m in CntrlModAlt {
              if  currentpart:hasmodule(m){
                if getEvAct(CurrentPart,m,CSaxis[axsel],30) = true {set ans to "inactive". set brpc to "RED". }else{ set ans to "active  ".}
                if getEvAct(CurrentPart,m,CSaxis[axsel],3) = true {set DplyAng to getEvAct(CurrentPart,m,"Deploy Angle",30). if DplyAng:typename = "Scalar" set trim to 0-round(DplyAng,0). break.}
              }
            }
            set hudopts[1][1] to  CSaxis[axsel].
            set hudopts[1][2] to " control:".
            set hudopts[1][3] to getcolor(ans+"                     ",brpc).
            if ItmTrg = "  RETRACT " {
              IF CSaxis[axsel] = "Pitch" {
                set BTHD11 to " TRIM UP ".
                set BTHD10 to " TRIM DN  ".
              }ELSE{
                set BTHD11 to " ANGLE UP ".
                set BTHD10 to " ANGLE DN ".
              }
            }else{
              set BTHD10 to EmptyHud. 
              set BTHD11 to EmptyHud.
            }}
          ELSE{
          if itemnumcur = ISRUTag {set DispInfo to 41.SET HDXT TO "RSRC".}
          ELSE{
          if itemnumcur = CapTag {set DispInfo to 42.}
          ELSE{
          if itemnumcur = RBTTag {
            set DispInfo to 23.
            if pl[0]:hasmodule("ModuleRoboticController"){
              for i in RANGE(1,10,3){
                SET modulelist[itemnumcur][i] TO "ModuleRoboticController". 
                set modulelistRPT[itemnumcur][i] to KALModLst[1][4].
              }
              set ItmTrg to "PLAY/PAUSE".
              set BTHD10 to "LOOP MODE ".
              set BTHD11 to "DIRECTION ".
              IF ROWVAL = 1 set BTHD11 to "ENAB/DISAB".
            }
              else{ 
              if autoRstList[0][0][tagnumcur] = 0 set BTHD11 to "  NO LOCK ".       
              ELSE if autoRstList[0][0][tagnumcur] > 0 set BTHD11 to "AUTO:"+autoRstList[0][0][tagnumcur]+" SEC".
              set MtrCur[4] to 4. 
              set MtrCur[3] to 3.
              SET HDXT TO "OPTN". 
                        local count to 0.
                        for MD in RBTModLst[0]{
                          if CurrentPart:modules:contains(MD){
                            for i in RANGE(1,11,3){
                              SET modulelist[RBTTag][i] TO MD. 
                            }
                            SET modulelistRPT[RBTTag][1] TO RBTModLst[2][count]. 
                            set modulelistRPT[RBTTag][4] to "toggle locked".
                            set modulelistRPT[RBTTag][7] to RBTModLst[3][count].
                            set modulelistRPT[RBTTag][10] to RBTModLst[4][count].
                            local ccc to RBTModLst[5][count]:split("/").
                            if MD = "ModuleRoboticServoPiston"{
                              if CurrentPart:title:contains("1p2") set ccc[1] to "0.8".
                              if CurrentPart:title:contains("1p4") set ccc[1] to "2.4".
                              if CurrentPart:title:contains("3p6") set ccc[1] to "1.6".
                              if CurrentPart:title:contains("3pt") set ccc[1] to "4.8".
                              if ccc[1] > 1 set ccc[2] to ".1".
                              if ccc[1] > 2 set ccc[2] to ".5".
                            }
                            if MD = "ModuleRoboticServoHinge"{
                              if CurrentPart:title:contains("G-00") {set ccc[0] to "-90". set ccc[1] to "90".}
                              if CurrentPart:title:contains("G-11") {set ccc[0] to "-90". set ccc[1] to "90".}
                            }
                            if MtrCur[5] = 4{
                              set MtrCur[0] to ccc[0]:tonumber.//min
                              set MtrCur[1] to ccc[1]:tonumber.//max
                              set MtrCur[2] to ccc[2]:tonumber.//adjby
                            }
                            
                            break.
                          }set count to count+1.
                        }
            }
          }
          else{
          if itemnumcur = Radartag {set DispInfo to 21.}
          ELSE{
          if itemnumcur = RCStag {
            set DispInfo to 62. 
            local ans to "".
            if rowval=1{SET HDXT TO "AXIS".
              set PrvGRP TO CHECKOPT(RCSaxis[0], Raxsel,"-",RCSaxis,1,1).
              set nxtGRP TO CHECKOPT(RCSaxis[0], Raxsel,"+",RCSaxis).
            }
            local brpc to "CYN".
            getEvAct(CurrentPart,"ModuleRCSFX","show actuation toggles",10).
            if getEvAct(CurrentPart,"ModuleRCSFX",RCSaxis[Raxsel],30) = false {set ans to "inactive". set brpc to "RED".}else{set ans to "active  ".}
            if rowval = 1 printline("Use Enter Button to Turn Axis Control off or on.","WHT").
            set hudopts[1][1] to  RCSaxis[Raxsel].
            set hudopts[1][2] to " control:".
            set hudopts[1][3] to getcolor(ans+"                     ",brpc).}
          ELSE{
          if itemnumcur = scitag {
            set DispInfo to 11.
            local ccc to  getactions("OnOff",list("scansat"),itemnumcur, TagNumCur,2,1,list("start"), list("stop")).
            if ccc > 0{
              if ccc= 1 set bthd11 to "START SCAN".
              if ccc= 2 set bthd11 to "STOP  SCAN". 
            }
              for md in sciModData{
              if currentpart:hasmodule(md){
                local PM to currentpart:GetModule(md).
                if pm:hassuffix("data"){
                  if pm:Hasdata {
                    local test to Removespecial(pm:data[0]:title," while").
                    set test to Removespecial(test," just").
                    local Xdata to round(pm:data[0]:transmitvalue,2).
                    local Sdata to round(pm:data[0]:sciencevalue,2).
                    local lmt to 13+Sdata:tostring:length+Xdata:tostring:length.
                    if test:tostring:length > WidthLim-lmt set test to test:substring(0,WidthLim-lmt).
                    local brp to test+"-(RTN:"+Sdata+" XMIT:"+Xdata+")".
                    local brpc to "GRN".
                    if colorprint = 1 and brp:length < widthlim-8 set brpc to "WHT".
                    set botrow to GetColor(test+"-(RTN:"+Sdata+" XMIT:"+Xdata+")",brpc).
                    set BTHD10 to " TRANSMIT ".
                  }
                }
                if currentpart:hasmodule("scansat"){
                  local mdl to currentpart:getmodule("scansat").
                  set SciDsp to mdl:allfieldnames.
                  if SciDsp:contains("scan altitude"){
                    local scalt to mdl:getfield("scan altitude").
                    set scalt to scalt:split(">").
                    local IdealAlt to scalt[1].
                    set scalt to scalt[0]:split("-").
                    set scalt[0] to scalt[0]+"000".
                    set scalt[1] to scalt[1]:REPLACE("km", "000"). 
                    set IdealAlt to IdealAlt:REPLACE("km Ideal", "000"). 
                    SET scalt[0] to removeletters(SCALT[0],", :").
                    SET scalt[1] to removeletters(SCALT[1],", :").
                    SET IdealAlt to removeletters(IdealAlt,", :").
                    local altmin to scalt[0]:tonumber.
                    local altmax to scalt[1]:tonumber.
                    local altidl to idealalt:tonumber.
                    local po to bigempty2.
                    if SHIP:ALTITUDE < altmin set po to " TOO LOW! INCREASE ALT BY "+ (ALTMIN-ROUND(SHIP:altitude,0))+"M TO RUN. MIN:("+ALTMIN+")             ".
                    if SHIP:ALTITUDE > altmax set po to " TOO HIGH! DECREASE ALT BY "+((ROUND(SHIP:altitude,0))-altmax)+"M TO RUN. MAX("+ALTMAX+")             ".
                    if SHIP:ALTITUDE > altmin      and SHIP:ALTITUDE < altmax      { set po to " WITHIN SCAN ALT.".
                      if SHIP:ALTITUDE < altidl*.9 set po to PO+"INCREASE BY "+ (altidl*.9-ROUND(SHIP:altitude,0)) +"M TO REACH IDEAL RANGE:("+altidl*.9+"-"+altidl*1.1+")             ".
                      if SHIP:ALTITUDE > altidl*1.1 set po to PO+"DECREASE BY "+(ROUND(SHIP:altitude,0)-altidl*1.1)+"M TO REACH IDEAL RANGE:("+altidl*1.1+"-"+altidl*.9+")             ".
                    }
                    if SHIP:ALTITUDE > altidl*.9 and SHIP:ALTITUDE < altidl*1.1 set po to " WITHIN IDEAL RANGE:("+altidl*.9+"-"+altidl*1.1+")                            ".
                    LOCAL PO3 TO "                     ".
                    if bthd11 = "STOP  SCAN" set po3 to " SCANNER DEPLOYED                      ". ELSE SET PO3 TO " SCANNER RETRACTED                      ".
                    if SciDsp:contains("scan type") SET PO3 TO " SCAN:"+mdl:getfield("scan type")+":"+po3.
                    if po3:length > WidthLim set po3 to po3:substring(0,(WidthLim-2)).
                    printline(po3,0,13). 
                    printline(po,0,14).
                    set ln14 to 2.
                  }
                  if SciDsp:length > 0{
                  set hudopts[1][1] to "Scan Info:"+scipart.  
                  set hudopts[1][2] to ":"+SciDsp[scipart-1].
                  set hudopts[1][3] to ":"+mdl:getfield(SciDsp[scipart-1]).
                }else{set hudopts[1][1] to "No scan info".}
                set ln14 to 2.
                }else{
                   PRINTLINE("",0,14). if GrpDspList3[FLYTAG][1] <> 6 PRINTLINE("",0,13).
                  set SciDsp to pm:alleventnames.
                  if SciDsp:length = 0 set SciDsp to pm:allactionnames.
                  if SciDsp:length > 0{
                  set hudopts[1][2] to scipart.  
                  set hudopts[1][3] to ":"+SciDsp[scipart-1].
                  set hudopts[1][1] to "Experiment:".
                }else{set hudopts[1][1] to "No experiment or data full".}
                break.
              }}
            }
          if getactions("OnOff",SciModAlt,itemnumcur, TagNumCur,1,1,list("review","review")) <> 0 set itmtrg to "  DELETE  ".
          if getactions("OnOff",SciModAlt,itemnumcur, TagNumCur,3,1,list("transmit"), list("transmit")) = 0 and BTHD10 <> " TRANSMIT "{
            local actn to GetActions(1,AnimModAlt,itemnumcur, TagNumCur,2,1,list("deploy","extend"),list("retract","close")).
            if actn = 0 {set BTHD10 to EmptyHud.} else{ if actn = 3 set actn to 1.
              if actn < 3 {
                set GrpDspList2[itemnumcur][TagNumCur] to actn+2. 
                set BTHD10 to grpopslist[itemnumcur][TagNumCur][GrpDspList2[itemnumcur][TagNumCur]]. 
              }
            }
          }
          if getactions("OnOff",list("ModuleScienceContainer"),itemnumcur, TagNumCur,3,2,list("collect")) <> 0 {
            local amt to list(0,0,0).
            set cnt to 0.
            local spc to "     ".
            if colorprint = 1 set spc to "   ".
            if  currentpart:hasmodule("ModuleScienceContainer"){
            set BTHD11 to " CLCT SCI ".
              for dt in currentpart:getmodule("ModuleScienceContainer"):data {
                set cnt to cnt+1.
                set amt[0] to round(amt[0]+dt:sciencevalue,2).
                set amt[1] to round(amt[1]+dt:transmitvalue,2).
                set amt[2] to round(amt[2]+dt:DATAAMOUNT,2).
              }
            set botrow to GetColor(cnt+" Experiments"+SPC+"Data:"+amt[2]+spc+"Science Val:"+amt[0]+spc+"Xmit Val:"+amt[1]+spc,"WHT").
            }
          }else{
            if GetActions(1,SciModAlt,itemnumcur, TagNumCur,3,1,list("reset"), list("reset")) <> 0 {set BTHD11 to "  RESET   ".}
          }
            }
          else{
          if itemnumcur = EngTag  {
          IF currentpart:hasmodule("MultiModeEngine"){}else{set BTHD10 to emptyhud.} set DispInfo to 11.}
          ELSE{
          IF itemnumcur = cmtag {set DispInfo to 42.}
          ELSE{
          IF itemnumcur = labtag {set DispInfo to 43.
            if getactions("OnOff",list("ModuleScienceContainer"),itemnumcur, TagNumCur,3,2,list("collect")) <> 0 set BTHD11 to " CLCT SCI ".
          }
          ELSE{
          IF itemnumcur = CMtag {set DispInfo to 51.}
          ELSE{
          if itemnumcur = WMGRtag   {
            set DispInfo to 25.
            set rowT2 to "Team:".
            set rowT1 to ":".
            if rowval = 0 {set BTHD11 to "NEXT TEAM ".}
            if rowval = 1 and Radartag > 0{ set BTHD10 to "NEXT TRGT ".}
          }
          ELSE{
          if itemnumcur = BDPtag   {
            set DispInfo to 24. 
            set MtrCur[4] to 12. 
            set MtrCur[3] to 1. 
            SET HDXT TO "OPTN". 
          }
          ELSE{
          if itemnumcur = dcptag   {
            if tagNumPrv <> TagNumCur  if not autoRscList[hsel[2][1]][hsel[2][2]]:istype("string") set RscSelection to autoRscList[hsel[2][1]][hsel[2][2]].
            SET AutoValList[0][0][3][15] TO 1.
          if DcpPrtList[hsel[2][2]][1] = "" {set fuelmon to 0.}
          else{
            IF DCPRes = 0 {
              local rscl to getRSCList(DcpPrtList[hsel[2][2]][1]:resources).
              set prsclist to rscl[0].
              set prsclist2 to rscl[2].
              set pRscNum to rscl[1].
              SET DCPRes TO 1.
            }
            if HudOpts[2][2][TagNumCur]:contains("Payload") or prsclist:length=0 {set fuelmon to 0.}else{set fuelmon to 1.}
            if rowval=1{SET HDXT TO " RSC".
              if prsclist2[0] <> "" and fuelmon = 1{
                set PrvGRP TO CHECKOPT(prsclist2:length-1, RscSelection,"-",prsclist2,0,1).
                set nxtGRP TO CHECKOPT(prsclist2:length-1, RscSelection,"+",prsclist2,0).
              }
            }
          }
            set dispinfo to 0.
            if getactions("OnOff",list("ModuleToggleCrossfeed"),itemnumcur, TagNumCur,1,1,list("enable"),list("disable")) = 0 set bthd10 to EmptyHud.
            if currentpart:hasmodule("ModuleAnimateGeneric"){
              local pm to currentpart:getmodule("ModuleAnimateGeneric"):allactionnames.
              set pm2 to currentpart:getmodule("ModuleAnimateGeneric"):ALLEVENTNAMES.
              set pm3 to list().
              for itm in pm pm3:add(itm).
              for itm in pm2 pm3:add(itm).
              for k in range (0,pm3:length){
                  SET BTHD11 TO EmptyHud.
                  if pm3[k]:contains("inflate") set BTHD11 to " INFLATE  ".
                  if pm3[k]:contains("deflate") set BTHD11 to " DEFLATE  ".
                  if pm3[k]:contains("deploy")  set BTHD11 to "  DEPLOY  ".
              }
            } 

          }
          ELSE{
          if mks = 1 {
            if itemnumcur = DEPOtag   {set DispInfo to 21.}
            ELSE{
            if itemnumcur = PWRTag {set DispInfo to 41.
            if currentPart:hasmodule("USI_InertialDampener"){
              local OnOff to CurrentPart:Getmodule("USI_InertialDampener"):alleventnames[0].
              if OnOff = "ground tether: off" set BTHD11 to " TETHR OFF".
              if OnOff = "ground tether: on" set BTHD11 to  " TETHR ON ".
            }
            SET HDXT TO "    ".
            set BayLst to GetMultiModule(CurrentPart,"recipe").
            if currentpart:hasmodule("USI_Converter"){ set BayTrg to GetMultiModule(CurrentPart,"","USI_Converter").}
            }
            else{
            if itemnumcur = MksDrlTag {
              set DispInfo to 41.
              }
              else{
              if itemnumcur = CnstTag {}
              else{
              if itemnumcur = DcnstTag {}
              else{
              if itemnumcur = habTag {
                if currentpart:hasmodule("USI_BasicDeployableModule"){
                if currentpart:getmodule("USI_BasicDeployableModule"):hasfield("paid"){ 
                  set PaidMeter to currentpart:getmodule("USI_BasicDeployableModule"):getfield("paid")*100.
                  set DispInfo to 61. set alttag to 1.
                  set hudopts[1][2] to ":".
                  set hudopts[1][1] to "Paid".
                  set hudopts[1][3] to SetGauge(PaidMeter/100*100,1,widthlim-7).
                }}
              }
              else{}}}}}}
          }
          else{}}}}}}}}}}}}}}}}}}}}}}}}}}}
            if MtrCur[5] < MtrCur[3] set MtrCur[5] to MtrCur[3].
            if MtrCur[5] > MtrCur[4] set MtrCur[5] to MtrCur[4].
          if hudop <> 5 set actnlist to list(1,ItmTrg,BTHD10,BTHD11,EmptyHud).
          }
          IF HUDOP = 5{ //set auto section
            set HudOptsR[5] to"AUTO"+MODESHRT[AutoSetMode].
            set PrvITM to actnlist[AutoSetAct].
            set ItmTrg to MODELONG[AutoSetMode].
            local topprint to bigempty.
            set BTHD10 TO HudRstMdLst[AutoRstMode].
            set BTHD11 TO "   CLEAR  ".
            if h5mode <> 1 set eng[4] to "  DELAY   ". else set eng[4] to "**DELAY** ".
            PRINTLINE("|  ACTION  |   MODE   |").
            print " AFTER TRIGGER" at (32,17).
            PRINT HudOpts[2][1][HSEL[2][1]]+ ":" + HudOpts[2][2][HSEL[2][2]] + ":" + HudOpts[2][3] at (2,hudstart-2).
            LOCAL MODEPRINT TO Removespecial(ItmTrg,"   ").
            set   MODEPRINT TO Removespecial(MODEPRINT,"  ").
            IF MODEPRINT = "ALTAGL" SET MODEPRINT TO "ALT AGL".
            if AutoSetAct > actnlist:length-1 set AutoSetAct to 1.
            LOCAL ActionPrint TO actnlist[AutoSetAct].
            if ActionPrint:LENGTH > 0 {IF ActionPrint[ActionPrint:LENGTH-1] <> " " SET ActionPrint TO ActionPrint+" ".}
            IF ActionPrint[0] <> " " SET ActionPrint TO " "+ActionPrint.
            LOCAL AftTrgPrint TO "".
            local ValuePrint to "".
            LOCAL DelayPrint TO "".
            local infoprint to bigempty2.
            print "                              " at (50,10).
            if AutoSetMode = 6 {
              set nxtITM TO "  SEl RSC ".
              local RscNme to RscList[RscSelection][0].
              LOCAL RSNM TO RscList[RscNum[RscNme]][1].
              print  RSNM AT (WidthLim-RSNM:length,10).
              if ship:resources:tostring:contains(RscNum[RscNme]:tostring){ 
                LOCAL RESPCT TO ROUND(ship:resources[RscNum[RscNme]]:amount/ship:resources[RscNum[RscNme]]:capacity*100,0).
                  local lm to 70-RSNM:length-ClrMin. 
                  local fmtr to RESPCT.
                  local lcl to MtrColor(fmtr).
                  SET InfoPrint to RSNM+"("+RESPCT+"%)"+GETCOLOR(SetGauge(RESPCT,0,lm),lcl).}
                  set ValuePrint to AUTOHUD[0]+" %".
            }
            else{
                set nxtITM TO EmptyHud.   
                if AutoSetMode = 2{ set ValuePrint to  AUTOHUD[0]+      " M/S".  set infoprint to "CURRENT SPEED:"+round(SHIP:VELOCITY:SURFACE:MAG,0)+" M/S".}else{
                if AutoSetMode = 3{ set ValuePrint to  AUTOHUD[0]+      " M".    set infoprint to "CURRENT ALTITUDE:"+round(SHIP:ALTITUDE,0)+" M".
                if body:atm:exists  set topprint to " ATMOSPHERE HEIGHT:"+body:atm:height+" M".   
                }else{
                if AutoSetMode = 4{ set ValuePrint to  AUTOHUD[0]+      " M AGL".set infoprint to "CURRENT RADAR ALTITUDE:"+round(ALT:RADAR-Height,0)+" M AGL".
                if body:atm:exists  set topprint to " ATMOSPHERE HEIGHT:"+body:atm:height+" M". 
                }else{
                if AutoSetMode = 5{ set ValuePrint to  AUTOHUD[0]+      " %".    set infoprint to "CURRENT ELECTRIC CHARGE:"+round(ship:electriccharge/ecmax*100,0)+" %".}else{
                if AutoSetMode = 7{ set ValuePrint to  AUTOHUD[0]+      " %".    set infoprint to "CURRENT THROTTLE:"+round(THROTTLE,0)+" THRTL".}else{
                if AutoSetMode = 8{ set ValuePrint to  AUTOHUD[0]+      " kPa".  set infoprint to "CURRENT PRESSURE:"+round(SHIP:SENSORS:PRES,0)+" kPa".}else{
                if AutoSetMode = 9{ set ValuePrint to  AUTOHUD[0]*0.01+ " EXP".  set infoprint to "CURRENT SUN EXPOSURE:"+round(SHIP:SENSORS:LIGHT,0)+" EXP".}else{
                if AutoSetMode = 10{set ValuePrint to  AUTOHUD[0]+      " K".    set infoprint to "CURRENT TEMPERATURE:"+round(SHIP:SENSORS:TEMP,1)+" K".}else{
                if AutoSetMode = 11{set ValuePrint to  AUTOHUD[0]*0.01+ " M/S2". set infoprint to "CURRENT GRAVITY:"+round(ship:sensors:grav:mag,1)+" M/S2".}else{
                if AutoSetMode = 12{set ValuePrint to  AUTOHUD[0]*0.01+ " G".    set infoprint to "CURRENT ACCELERATION:"+round(ship:sensors:acc:mag,1)+" G".}else{
                if AutoSetMode = 13{set ValuePrint to  AUTOHUD[0]*0.01      .    set infoprint to "CURRENT THRUST TO WEIGHT:"+TWR.}else{
                if AutoSetMode = 14 {
                  set nxtITM TO " SEL MODE ".
                  if StsSelection = 0 set StsSelection to 1. 
                  if StsSelection > STATUSOPTS[0] set StsSelection to STATUSOPTS[0]. 

                  print STATUSOPTS[StsSelection] AT (WidthLim-STATUSOPTS[StsSelection]:length,10).
                  set ValuePrint to  AUTOHUD[0].    
                  set infoprint to "TRIGGER ON STATUS:"+STATUSOPTS[StsSelection]+"             CURRENT STATUS:"+SHIP:status. 
                  IF AutoRstMode = 2 or AutoRstMode = 3 set AutoRstMode to 4.  
                }
                else{
                if AutoSetMode = 15{
                  set nxtITM TO "  SEl RSC ".
                  //local RscNme to prsclist[RscSelection][0].
                  LOCAL RSNM TO prsclist[RscSelection][1].
                  print  RSNM AT (WidthLim-RSNM:length,10).
                  local lm to 56-ClrMin-RSNM:length.
                  local fmtr to GetFuelLeft(DcpPrtList[hsel[2][2]],3,0,RscSelection).
                  local lcl to MtrColor(fmtr).
                  set ValuePrint to  AUTOHUD[0]+      " FUEL". set infoprint to "CURRENT "+RSNM+" IN PART:"+ GETCOLOR("("+fmtr+"%)"+GetFuelLeft(DcpPrtList[hsel[2][2]],0,lm,RscSelection),lcl).
                }
                }}}}}}}}}}}
              }
            }
            IF  AutoRstMode = 1 SET AftTrgPrint TO "DISABLE".
            IF  AutoRstMode = 2 if AUTOHUD[2] = " UNDER " { SET AftTrgPrint TO "SWITCH TO OVER".}ELSE{SET AftTrgPrint TO "SWITCH TO UNDER".}.
            IF AUTOHUD[2] = " UNDER " { SET ValuePrint TO "UNDER "+ValuePrint.
              IF AutoRstMode = 4 {SET AftTrgPrint TO "WAIT FOR UNDER".}
              IF AutoRstMode = 3 {SET ActionPrint TO "RESET ". SET AftTrgPrint TO "WAIT FOR OVER".}
            }
            IF AUTOHUD[2] = "  OVER " {SET ValuePrint TO "OVER "+ValuePrint.
              IF AutoRstMode = 3 {SET AftTrgPrint TO "WAIT FOR OVER".}
              IF AutoRstMode = 4 {SET ActionPrint TO "RESET ".  SET AftTrgPrint TO "WAIT FOR UNDER".}
            }
            if setdelay > 0{SET DelayPrint TO "WAIT "+setdelay+" SEC".} ELSE SET DelayPrint TO "".
            LOCAL LCL TO "WHT".
            if dctnmode = 1 {      
              set topprint to "WONT START DETECTION UNTIL AFTER "+REMOVESPECIAL(ItemListHUD[HdItm]," ")+":"+Prttaglist[HdItm][hdtag]+" IS TRIGGERED".
              SET LCL TO "ORN".
            }
            if dctnmode = 2 {      
              set topprint to "WILL TRIGGER WHEN "+REMOVESPECIAL(ItemListHUD[HdItm]," ")+":"+Prttaglist[HdItm][hdtag]+" IS TRIGGERED.".
              SET LCL TO "YLW".
            }
            if h5mode = 1 {      
              set topprint to "CURRENTLY SETTING DELAY TIME. PRESS DELAY TO SET".
              SET LCL TO "YLW".
            }
            PRINTLINE(" "+topprint,LCL,13).
            PRINTLINE(" "+InfoPrint,0,14). 
            set ln14 to 2.
            PRINTLINE("",0,16). 
            IF AutoSetMode <> 1{
              if AutoSetMode = 14 { set valueprint to STATUSOPTS[StsSelection]. IF AUTOHUD[0] = 0 set autohud[0] to 1.}
                IF AUTOHUD[0] <> 0 {
                  PRINTLINE( DelayPrint+ActionPrint+"when "+MODEPRINT+" is "+ValuePrint+" then "+AftTrgPrint,0,16).
                   print ActionPrint AT (WidthLim-ActionPrint:length,ACP).
                  }
                ELSE{PRINT "VALUE NOT SET" at (1,16).}
              
            }ELSE{    PRINT "MODE NOT SET" at (1,16). PRINT "               " AT (widthlim-15,ACP).}
          }
          ELSE{ //hudop <> 5
           set HudOptsR[5] to"AUTO"+MODESHRT[AutoCurMode].
           
              SETHUD().
              if DispInfo = 1 {
                local lcl to "GRN".
                if GrpDspList[itemnumcur][TagNumCur] = 1 or GrpDspList[itemnumcur][TagNumCur] = 5 set lcl to "RED".
                if GrpDspList[itemnumcur][TagNumCur] = 2 or GrpDspList[itemnumcur][TagNumCur] = 6 set lcl to "CYN".
                set HudOpts[1][1] to getcolor(modulelistRpt[itemnumcur][statusdispnum],lcl).
              }
              ELSE{
                if ItemNumPrv <> itemnumcur or TagNumCur <> tagNumPrv or forcerefresh > 0{
                if  DispInfo > 1 UPDATESTATUSROW().}
              }

              set ItemNumPrv to itemnumcur.
              set tagNumPrv to TagNumCur.
                //#region hudset high
                  PRINTLINE(" "+HudOpts[2][1][HSEL[2][1]]+ ":" + HudOpts[2][2][HSEL[2][2]] + ":" + HudOpts[2][3],0,hudstart-2).  
                //#endregion
            IF HudOptsR[6] = 0 {SET OVUN TO "     ".}else{
              IF HudOptsR[6] < 0 {SET OVUN TO "UNDER ". set AUTOHUD[2] to " UNDER ". }
              IF HudOptsR[6] > 0 {SET OVUN TO " OVER ". set AUTOHUD[2] to "  OVER ". } 
            }
            if ovun = "UNDER " and  AutoRstMode = 3 set ovun to "RESET ".
            if ovun = " OVER " and  AutoRstMode = 4 set ovun to "RESET ".
            if h5mode = 1  set ovun to "DELAY ".
            SET numloc1 to widthlim-6-HudOptsR[6]:tostring:length.
            local valprint to HudOptsR[6].
            if AutoCurMode = 9 or AutoCurMode = 11 or AutoCurMode = 12  or AutoCurMode = 13 {set valprint to valprint*.01. set NUMLOC1 to NUMLOC1-2.}
            PRINT "                         " AT (55,acp+2).
            if AutoCurMode <> 1 PRINT OVUN+ABS(valprint) AT (NUMLOC1,acp+2).
            set TrgLim to 1.
            if bthd10 <> emptyhud set TrgLim to 2.
            if bthd11 <> emptyhud set TrgLim to 3.
            set actnlist[0] to TrgLim.
          }
        }
      }
      else{//if no part
      if dbglog > 2 log2file("    NO PART"+ItemList[itemnumcur]+":"+prtTagList[itemnumcur][TagNumCur]).
            set hudopts[1][1] to "NO PART".
            set hudopts[1][2] to "".
            set hudopts[1][3] to "".
            set DispInfo to 10.
            set BTHD10 to EmptyHud. 
            set BTHD11 to EmptyHud.
            set ITMTRG to EmptyHud.
            PRINTLINE().
            PRINTLINE("",0,hudstart-2). 
            PRINT HudOpts[2][1][HSEL[2][1]]+ ":" + HudOpts[2][2][HSEL[2][2]] + ":" + HudOpts[2][3] at (2,hudstart-2).
            PRINTLINE("",0,hudstart-3).
            PRINT HudOpts[1][1]+ HudOpts[1][2]+ HudOpts[1][3] at (2,hudstart-3).   
            SET autoTRGList[0][itemnumcur][tagnumcur] TO 0-abs(AutoCurMode)-1.
      }
      //#endregion
      //#region MainPrint
          PRINT HudOptsR[5] AT (widthlim-8,acp+1).
              PRINT "            " AT (0,3).
              PRINT "                                                    " AT (0,7).
            print "                         " at (55,acp+3).
          //#region print if change
          IF HUDOP <> HUDOPPREV or forcerefresh > 0{

             IF HUDOP <> 5 PRINT HudOptsL[1][HUDOP] AT (0,1). PRINT HudOptsR[1][HUDOP] AT (widthlim-11,1).
              PRINT HudOptsL[2][HUDOP] AT (0,2). PRINT HudOptsR[2][HUDOP] AT (widthlim-6,2).
              PRINT HudOptsL[3][HUDOP] AT (0,5). PRINT HudOptsR[3][HUDOP] AT (widthlim-8,5).
              PRINT HudOptsL[4][HUDOP] AT (0,6). PRINT HudOptsR[4][HUDOP] AT (widthlim-8,6).
               if hudop < 6 {                    PRINT HudOptsR[7][HUDOP] AT (widthlim-11,12).
                                                 PRINT HudOptsR[8][HUDOP] AT (widthlim-4,13).}
              if hudop=5 {
                local numloc1 to widthlim-12-AUTOHUD[0]:tostring:length.
                local valprint to AUTOHUD[0].
                local adjprint to AutoAdjByLst[AUTOHUD[1]].
                if AutoSetMode = 9 or AutoSetMode = 11 or AutoSetMode = 12 or AutoSetMode = 13 {set valprint to valprint*.01. set NUMLOC1 to NUMLOC1-2. set adjprint to adjprint*.01.}
                print "NOT SAVED" AT (61,acp+1).
                ///print "          " AT (70,acp+2).
                PRINT "              "+AUTOHUD[2]+ABS(valprint) AT (NUMLOC1-9,acp+2).
                if AutoSetMode = 14 PRINT "   ON STATUS" AT (widthlim-12,acp+2).
                PRINT adjprint AT (0,6).
                PRINT AUTOHUD[2] AT (0,3).}
              else{//hudop <> 5
              PRINT PrvGRP AT (0,3).
              PRINT nxtGRP AT (0,7).
                if hudop < 6 and AutoSetMode <> 1{      
                  if AutoSetAct > actnlist:length-1 set AutoSetAct to 1.  
                    print actnlist[AutoSetAct] AT (WidthLim-actnlist[AutoSetAct]:length,ACP).
                    if AutoSetMode = 14 AND AutoValList[itemnumcur][TagNumCur] > 0 print STATUSOPTS[StsSelection] AT (WidthLim-STATUSOPTS[StsSelection]:length,acp+3). 
                    else{
                      if AutoSetMode = 6 {
                        local rscnm to autoRscList[itemnumcur][TagNumCur].
                        if rscnm:istype("string") set rscnm to RscNum[rscnm].
                        local arsc to RscList[rscnm].
                        print  arsc[1]+"("+ROUND(ship:resources[arsc[3]]:amount/arsc[2]*100,0)+"%)" AT (widthlim-5-arsc[1]:length,acp+3). }
                      else{
                        if AutoSetMode = 15 AND PRscList:LENGTH > 0{
                          local ARSC to PRscList[autoRscList[itemnumcur][TagNumCur]][0].
                          if itemnumcur = dcptag {print  arsc AT (widthlim-6-arsc:length,acp+3).}
                        }
                      }
                    }
                }else{print "               " AT (65,acp).}//print "                         " at (55,acp+2). print "                         " at (55,acp+3).}
              }
          IF HUDOP > 6 {
            print "       Set" at (widthlim-10,8).
            print "           "+HDXT at (65,9).
            if itemnumcur = FlyTag{
               print "   "+AutoAdjByLst[AUTOHUD[1]] at (widthlim-AutoAdjByLst[AUTOHUD[1]]:TOSTRING:length-3,10).
               print "    MORE" at (widthlim-8,12).

            }
          }else{ IF AutoSetMode <> 1 {
            if AutoCurMode = 14 PRINT "   ON STATUS" AT (widthlim-12,acp+2).
            if autoTRGList[0][itemnumcur][TagNumCur] > 0{print "DELAY "+autoTRGList[0][itemnumcur][TagNumCur] AT (widthlim-6-autoTRGList[0][itemnumcur][TagNumCur]:tostring:length,acp+4).}else{print "            " at (widthlim-12,acp+4).}
          }
            if hudop = 6{
              print "       RUN" at (widthlim-10,8).
              print "     EXPERIMENT" at (widthlim-15,9).
            }
          }                  
          if colorprint > 0{
            local itmtrg2 to itmtrg.
            local PrvITM2 to PrvITM.
            PRINT "|          |          |          |          |          |" at (17,18).
            if hudop <> 5{
              if findcl2:HASKEY(itmtrg){set itmtrg2 to  getcolor(itmtrg,FindCl2[itmtrg]).}
                else{
                  if GrpDspList[itemnumcur][TagNumCur]  = 1 set itmtrg2 to "[#00FFFF]"+itmtrg+"{COLOR}".
                  if GrpDspList[itemnumcur][TagNumCur]  = 2 set itmtrg2 to "[#ff0000]"+itmtrg+"{COLOR}".
                }
              }
            else{
              if GrpDspList[itemnumcur][TagNumCur] = 1 set PrvITM2 to "[#00FFFF]"+PrvITM+"{COLOR}".
              if GrpDspList[itemnumcur][TagNumCur] = 2 set PrvITM2 to "[#ff0000]"+PrvITM+"{COLOR}".}
              PRINT BIGEMPTY2 AT (1,18).
              PRINT " |"+PrvITM2+"|"+ItmTrg2+"|"+nxtITM+"|"+BTHD10+"|" at (0,18). 
            PRINT BTHD11+"|" at (62,18).
          }
          else{PRINT " |"+PrvITM+"|"+ItmTrg+"|"+nxtITM+"|"+BTHD10+"|"+BTHD11+"|"+BTHD12+"|          |" at (0,18).}
          }
          SET HUDOPPREV TO HUDOP.
          if forcerefresh = 1 set forcerefresh to 0.
          //#endregion
          //#region alwaysprint
          //#region warnings and notiifications
            if AutoDspList[hsel[2][1]][hsel[2][2]] < 0 and AutoDspList[0][hsel[2][1]][hsel[2][2]][0] <> 0 {
              set ln14 to 2.
              local splt to AutoDspList[0][hsel[2][1]][hsel[2][2]][0]:split("-").
              if splt:length = 3 PRINTLINE("WONT START DETECTION UNTIL AFTER "+REMOVESPECIAL(ItemListHUD[splt[0]:tonumber]," ")+":"+Prttaglist[splt[0]:tonumber][splt[1]:tonumber]+" IS TRIGGERED","ORN",13).
              if splt:length = 4 PRINTLINE("WILL TRIGGER WHEN "+REMOVESPECIAL(ItemListHUD[splt[0]:tonumber]," ")+":"+Prttaglist[splt[0]:tonumber][splt[1]:tonumber]+" IS TRIGGERED","YLW",13).
            }
          if loadbkp = 2 {set line to 1. set isdone to 1.}
          if SAVEbkp = 2 {SaveAutoSettings(2). printline(" BACKUP FILE SAVED","CYN").  PRINTLINE("",0,13).  PRINTLINE("",0,14).  SET SAVEBKP TO 0. }
          if SHIP:status <> ShipStatPREV{
            IF STATUSSPACE:CONTAINS(SHIP:status){SET FlState to "Space". if body:atm:exists SET FlState to "SpaceATM".}
            IF STATUSLAND:CONTAINS(SHIP:status) SET FlState to "Land".
            if ship:status = "FLYING" SET FlState to "Flight".
            set ShipStatPREV to ship:status.
          }
          for i in range(1,prtTagList[engtag][0]+1){
            set fo to 0.
            if prtlist[engtag][I][1]:HASSUFFIX("FLAMEOUT"){
              if prtlist[engtag][I][1]:FLAMEOUT and PrtListcur:contains(prtlist[engtag][I][1]){set fo to 1. BREAK.}
            }
          }

          LOCAL PRLCL TO 14.
          IF RUNAUTO <> 1 SET PRLCL TO 13.
          if itemnumcur = LIGHTTAG AND TagNumCur = 1{
            if loadbkp = 1  {IF file_exists(autofileBAK) print " CLICK ONE MORE TIME TO LOAD FROM BACKUP " at (1,PRLCL). ELSE print " NO BACKUP FILE TO LOAD FROM " at (1,PRLCL).}
            if SAVEbkp = 1  {print " CLICK ONE MORE TIME TO SAVE TO BACKUP " at (1,PRLCL).}
          }
          //#endregion
          FOR clearPips IN RANGE(0, 3){PRINT " " at (0,hudstart-clearPips).}
          PRINT ">" at (0,hudstart-RowSel).
          //#endregion
          //#endregion
   }
   FUNCTION UPDATESTATUSROW{
    LOCAL br TO 0.
    local lcl to 0.
              if hudop = 5 or itemnumcur = dcptag return.
                LOCAL LF TO 0.
                if ship:resources:tostring:contains("liquidfuel"){//if ship resources has resource
                  LOCAL FuelLeft TO ROUND(ship:resources[RscNum["liquidfuel"]]:amount/ship:resources[RscNum["liquidfuel"]]:capacity*100,0).
                  if FuelLeft < 1                                                         printline(" WARNING FUEL EMPTY                                                   ","RED",14).else
                  if FuelLeft < 5                                                         printline(" WARNING FUEL CRITICALLY LOW                                          ","ORN",14).else
                  if FuelLeft < 10                                                        printline(" WARNING FUEL LOW                                                     ","YLW",14).
                  if FuelLeft < 10 {SET LF TO 1. set ln14 to 1.}
                }
                IF LF <> 1 AND itemnumcur <> SCITAG{
                  if runauto = 2 {
                    if SHIP:status = "PRELAUNCH" {                                        printline(" PRELAUNCH. AUTO TRIGGERS DISABLED UNTIL AFTER LAUNCH.                 ","YLW",14). set ln14 to 1.}
                      else {if IsPayload[0] = 1 {set RunAuto to 0. SET refreshRateSlow TO 10. set refreshRateFast to 10. set RFSBAak to refreshRateSlow.}else set runauto to 1. 
                                                                                          printline("                                                                       ",0,14). set ln14 to 1.}}
                    ELSE{
                      if runauto = 3                               {                      printline(" AUTO TRIGGERS DISABLED. CHANGE SETTING IN ACTION GROUP ITEM.          ","ORN",14). set ln14 to 1.}
                    else{
                      if runauto = 0                               {                      printline(" PAYLOAD PART. AUTO TRIGGERS DISABLED UNTIL 10 SECONDS AFTER DECOUPLE.","YLW",14). set ln14 to 1.}
                    ELSE{
                      if AutoDspList[itemnumcur][TagNumCur] > 0 and runauto <> runautobak{printline("                                                                      ",0,14).}
                    }}}
                  IF RUNAUTO = 1{
                    if ship:electriccharge < 10                                          {printline(" WARNING LOW ELECTRIC CHARGE                                          ","RED",14). set ln14 to 1.}
                  }
                }
                set runautobak to runauto.
              if itemnumcur = ItemNumPrv{
                 local fl to "".
                 local halfmtr to "". 
                 set br TO rowsel.
                  if  hsel[2][1] <> sciTag set botrow to bigempty2.
                 if DispInfo > 10 {
                    local HudItem to hsel[2][1].
                    local hudtag to hsel[2][2].
                    local HudPrt to hsel[2][3].
                    local pl to prtList[HudItem][hudtag].
                    set pl to pl:sublist(1, pl:length).
                    local p to prtList[HudItem][hudtag][HudPrt].
                  if DispInfo = 11 {
                      IF HudItem = EngTag {
                        if BR =1{
                          IF p:HASMODULE("ModuleEnginesFX"){ 
                            set botrow to "Thrust Limit"+SetGauge(PrtList[HudItem][hudtag][1]:THRUSTLIMIT,1,widthlim-13).
                          }
                        }else{
                          if p:hassuffix("fuelflow") and p:hassuffix("maxfuelflow"){
                            set botrow to "Fuel Flow"+SetGauge(round((p:fuelflow/p:maxfuelflow)*100,1),1,widthlim-9).
                          }
                        }
                        IF p:hasmodule("ModuleGimbal")  set HudOpts[1][3] to "                Gimbal:"+getstatus(HudItem,hudtag,3,1,-1)+"  ".
                        local midtemp to "              Mode:"+getstatus(HudItem,hudtag,2,1,-1).
                        local stat to getstatus(HudItem,hudtag,1,1,-1).
                        if stat = "off" and GrpDspList[HudItem][hudtag] = 2 set stat to "on".
                        set hudopts[1][1] to "Engine Status:"+stat.
                        IF p:hasmodule("MultiModeEngine") set HudOpts[1][2] to midtemp.
                      }
                    }
                  else{
                  if DispInfo <30 {
                    if DispInfo = 21 {
                      set HudOpts[1][3] to getstatus(HudItem,hudtag,1,1)+"                     ". 
                      if HudItem = anttag {   
                        if rtech <> 0 {
                          if rtech:hasKSCconnection(ship) = True {printline("CONNECTED TO KSC WITH DELAY OF:"+rtech:kscdelay(ship)+"          ","WHT",14). set ln14 to 1.}
                          IF p:hasmodule("ModuleRTAntenna") if p:getmodule("ModuleRTAntenna"):HASFIELD("target"){
                            local  ct to p:getmodule("ModuleRTAntenna"):getFIELD("target"):tostring.
                            if ct:contains("VESSEL(") set ct to ct:substring(8,ct:length-10).
                            if ct:contains("BODY(") set ct to ct:substring(5,ct:length-7).
                            IF BR=1{set botrow to "set target to:"+trglst[anttrgsel].
                            if trglst[anttrgsel] = ct set lcl to "WHT". else set lcl to "YLW".}
                            else{set botrow to "Current target:"+ct. set lcl to "WHT".}
                          }
                          //ANTModLst //add ant options
                        }
                        set HudOpts[1][2] to ":".
                        if removespecial(hudopts[1][3]," ")="" or hudopts[1][3] = "locked"{
                          if GrpDspList[HudItem][hudtag] = 1 set HudOpts[1][2] to getcolor("RETRACTED  ","RED").
                          if GrpDspList[HudItem][hudtag] = 2 set HudOpts[1][2] to getcolor("EXTENDED   ","CYN").   
                        }               
                      }
                      IF HudItem = DOCKTAG{
                        if P:hassuffix("STATE") SET HudOpts[1][1] TO P:STATE.
                        if P:hassuffix("DOCKEDSHIPNAME") SET HudOpts[1][3] TO P:DOCKEDSHIPNAME.
                        Set HudOpts[1][2] TO "               ".
                      }
                    }
                    else{ 
                    if DispInfo = 22 {set HudOpts[1][3] to getstatus(HudItem,hudtag,2,1).}
                    else{
                    if DispInfo = 23 {
                      if HudItem = RBTTag{
                        if pl[0]:hasmodule("ModuleRoboticController"){
                          LOCAL PLP TO getstatus(HudItem,hudtag,1,1,-1).
                          IF PLP = 0 SET PLP TO "Playing". else set PLP to "Paused".
                          set PLP to "Status:"+PLP.
                          LOCAL LPM TO getstatus(HudItem,hudtag,2,1,-1).
                          IF LPM = 0 SET LPM TO "None". 
                          IF LPM = 1 set LPM to "Repeat".
                          IF LPM = 2 set LPM to "Ping Pong".
                          IF LPM = 3 set LPM to "None-Restart".
                          set LPM to "Loop Mode:"+LPM.
                          LOCAL TDR TO getstatus(HudItem,hudtag,3,1,-1).
                          IF TDR = 0 SET TDR TO "Foward". else set TDR to "Reverse".
                          set TDR to "Play Direction:"+TDR.
                          set HudOpts[1][3] to getstatus(HudItem,hudtag,4,1,-1)+" | "+PLP+" | "+LPM+" | "+TDR.
                          set plspd to getEvAct(pl[0],"ModuleRoboticController","Play Speed",30).
                          if plspd:istype("string") set plspd to plspd:tonumber.
                          set botrow to "Play Speed:"+SetGauge(Removespecial(plspd/mtrcur[1])*100,1,widthlim-16).
                        }
                        else{
                          local aaa to getstatus(HudItem,hudtag,MtrCur[5],1,2).
                          if BR >0{
                              LOCAL MDPRINT TO modulelistRPT[RBTTag][MtrCur[5]*3-2]. 
                              if MDPRINT:tostring:contains("(%)") set mtrcur[1] to 100.
                            IF AAA <> "                                    " {
                              local localguage to Removespecial(aaa:tonumber/mtrcur[1])*100. 
                              if br > 0  set botrow to MDPRINT+SetGauge(localguage,1,widthlim-4-MDPRINT:length).
                              SET BOTPREV TO "000".
                            }
                            print MDPRINT at (WidthLim-MDPRINT:length,10).
                          }
                            set HudOpts[1][3] to getstatus(HudItem,hudtag,4,1,-2). 
                            set HudOpts[1][3] to HudOpts[1][1]+HudOpts[1][2]+HudOpts[1][3]+"        ". 
                            set HudOpts[1][2] to ":"+getstatus(HudItem,hudtag,1,1,-2)+" - ".
                        }
                      }
                    }
                    else{  
                    if DispInfo = 24 {
                      if HudItem = BDPTag{
                          if PrtList[HudItem][hudtag][HudPrt]:modules:contains("BDModulePilotAI"){
                            set modulelistRPT[BDPTag][1] to BDPModLst[0][MtrCur[5]].
                            local ccc to "".
                            IF TUNECLAMP = 1 set ccc to BDPModLst[1][MtrCur[5]]:split("/").
                            IF TUNECLAMP = 0 set ccc to BDPModLst[2][MtrCur[5]]:split("/").
                            set MtrCur[0] to ccc[0]:tonumber.
                            set MtrCur[1] to ccc[1]:tonumber.
                            set MtrCur[2] to ccc[2]:tonumber.
                          }
                          local aaa to getstatus(HudItem,hudtag,1,1).
                          if BR >0{
                            IF AAA <> "                                    " {
                              local localguage to Removespecial(aaa:tonumber). 
                              SET localguage TO (localguage/MtrCur[1])*100.
                              if br > 0 set botrow to modulelistRPT[BDPTag][1]+SetGauge(localguage,1,widthlim-4-modulelistRPT[BDPTag][1]:length).
                            }
                            set HudOpts[1][1] to modulelistRPT[BDPTag][1]+":"+getstatus(HudItem,hudtag,1,1,2).
                            IF BR = 1 print BDPModLst[0][MtrCur[5]] at (WidthLim-BDPModLst[0][MtrCur[5]]:length,10).
                          }
                      }
                      if HudItem = GearTag{
                            SET modulelist[HudItem][10] TO GearModLst[0][MtrCur[5]]. 
                            set modulelistRPT[HudItem][10] to GearModLst[3][MtrCur[5]].
                            if pl[0]:hasmodule(GearModLst[0][MtrCur[5]]){
                              if pl[0]:getmodule(GearModLst[0][MtrCur[5]]):hasfield(GearModLst[3][MtrCur[5]]) {
                                   set statusinfo to getstatus(HudItem,hudtag,4,1).
                              }else set statusinfo to "                                    ".}
                            local ccc to GearModLst[5][MtrCur[5]]:split("/").
                            if ccc[0] <> "False"{
                            set MtrCur[0] to ccc[0]:tonumber.
                            set MtrCur[1] to ccc[1]:tonumber.
                            set MtrCur[2] to ccc[2]:tonumber.
                            }else{
                            set MtrCur[0] to 1.
                            set MtrCur[1] to 2.
                            set MtrCur[2] to -1.
                            }
                          if BR =1 AND  p:hasmodule("ModuleWheelDeployment"){
                              if ccc[0] <> "False" {
                                local ev to 1.
                                for pt in pl{
                                  if pt:hasmodule(GearModLst[0][MtrCur[5]]){if pt:getmodule(GearModLst[0][MtrCur[5]]):hasfield(GearModLst[3][MtrCur[5]]){}else{set ev to 2.}}
                                }
                                if ev = 1{
                                  local localguage to Removespecial(statusinfo:tonumber). 
                                  SET localguage TO (localguage/MtrCur[1])*100.
                                  set botrow to modulelistRPT[HudItem][10]+SetGauge(localguage,1,widthlim-4-modulelistRPT[HudItem][10]:length).
                                }else{set botrow to GearModLst[3][MtrCur[5]]+" Adjustment set to auto". set lcl to "YLW".}
                                
                             }
                             else{
                              if statusinfo:contains("False") {
                                set botrow to "steering direction: Reversed           " .set lcl to "YLW".}
                              else{
                                set botrow to "steering direction: Normal           ".set lcl to "CYN".}}
                             print GearModLst[3][MtrCur[5]] at (WidthLim-GearModLst[3][MtrCur[5]]:length,10).
                          }else{set botrow to bigempty2.}
                          if  p:hasmodule("ModuleWheelDeployment"){
                            set HudOpts[1][3] to Removespecial(rowT2+getstatus(HudItem,hudtag,3,1),"  ").
                            set HudOpts[1][2] to Removespecial(rowT1+getstatus(HudItem,hudtag,1,1),"  ")+"                              ".
                          }else{
                            if  p:hasmodule("ModuleAnimateGeneric") {
                              if GrpDspList[HudItem][hudtag] = 1 set HudOpts[1][2] to getcolor("RETRACTED  ","RED").
                              if GrpDspList[HudItem][hudtag] = 2 set HudOpts[1][2] to getcolor("EXTENDED   ","CYN").
                              set lcl to GrpDspList[HudItem][hudtag].
                            }

                          }
                      }
                    }
                    else{ 
                    if DispInfo = 25 {
                      set HudOpts[1][3] to rowT2+getstatus(HudItem,hudtag,2,1,-1).
                      set HudOpts[1][2] to rowT1+getstatus(HudItem,hudtag,1,1).
                      IF HudItem = CHUTETAG{
                        IF BR = 1{
                          SET BOTPREV TO "000".
                        LOCAL MDE TO CHUTEModLst[0][MtrCur[5]].
                        LOCAL SFX TO CHUTEModLst[2][MtrCur[5]].
                          local ccc to CHUTEModLst[1][MtrCur[5]]:split("/").
                          set MtrCur[0] to ccc[0]:tonumber.
                          set MtrCur[1] to ccc[1]:tonumber.
                          set MtrCur[2] to ccc[2]:tonumber.
                          FOR MD IN chuteModAlt{
                            for pt in pl{
                              if pt:hasmodule(MD){
                                if pt:getmodule(MD):hasfield(MDE){
                                  local AAA to getEvAct(pl[0],MD,MDE,30).
                                  set HudOpts[1][3] TO "". set HudOpts[1][2] TO "".
                                  print MDE at (WidthLim-MDE:length,10).
                                  IF MDE <> "deploy mode" {
                                    LOCAL localguage TO (AAA/MtrCur[1])*100.
                                    SET BOTROW TO MDE+SetGauge(localguage,1,widthlim-4-MDE:length).
                                    set HudOpts[1][1] to MDE+":"+ROUND(AAA,2)+SFX+"          ".
                                  }
                                  ELSE{
                                    LOCAL SPLT TO SFX:SPLIT("/").
                                    set HudOpts[1][1] to MDE+":"+SPLT[AAA]+"          ".
                                    SET BOTROW TO  MDE+":"+SPLT[AAA]+"          ".
                                  }
                                  BREAK.
                                }
                              }
                            }
                          }
                        }
                      }
                    }else{
                    if DispInfo = 26 {
                      set HudOpts[1][3] to rowT2+getstatus(HudItem,hudtag,3,1,-1).
                      set HudOpts[1][2] to rowT1+getstatus(HudItem,hudtag,1,1).
                    }
                    else{}}}}}}
                  }
                  else{
                  if DispInfo <40 {
                    if DispInfo = 31 {set HudOpts[1][3] to SetGauge(getstatus(HudItem,hudtag,1,1),1).}
                    else{ 
                    if DispInfo = 32 {set HudOpts[1][3] to SetGauge(getstatus(HudItem,hudtag,2,1),1).}
                    else{}}
                  }
                  else{
                  if DispInfo <50 {
                    if DispInfo = 41 {
                      local op to 2.
                      IF HudItem = DrillTag set op to 3.
                      IF HudItem = MksDrlTag set op to 4.
                      IF BR=1 {
                      local aaa to getstatus(HudItem,hudtag,op,1).
                      IF AAA = "                                    " {set halfmtr to "". }ELSE{
                      local bbb to removeletters(aaa).
                      local ccc to bbb:split("/").
                      local localguage to (ccc[0]:tonumber / ccc[1]:tonumber)*100.
                      set FullMtr to "core temp"+SetGauge(localguage,1,widthlim-11).
                      if br > 0 set botrow to FullMtr.
                      set HalfMtr to "core temp"+SetGauge(localguage,1,30).
                      }}
                      if mks > 0{
                        IF HudItem = PWRTag{
                          if prtList[HudItem][hudtag][HudPrt]:hasmodule("usi_converter"){
                            local t1 to prtList[HudItem][hudtag][HudPrt]:getmodule("usi_converter").
                            set fl to t1:allfieldnames[0].
                            if baylst[0] > 0{  
                              set fl to baytrg[baysel][0].                   
                              set t1 to prtlist[pwrtag][hudtag][1]:getmodulebyindex(baytrg[baysel][2]).
                            }
                            set hudopts[1][2] to "".
                            set hudopts[1][1] to fl.
                            if GrpDspList[HudItem][hudtag] = 2 set hudopts[1][3] to GetColor(":ACTIVE:","CYN"). 
                            if GrpDspList[HudItem][hudtag] = 1 set hudopts[1][3] to GetColor(":NOT ACTIVE:","RED").
                            if rowval = 1{
                              IF BR=1 {
                                local aaa to getstatus(HudItem,hudtag,3,1).
                                IF AAA <> "                                    " {
                                  local localguage to (aaa:tonumber / 1)*100. 
                                  if halfmtr = "" {set botrow to "Governor"+SetGauge(localguage,1,widthlim-11).}else{
                                  if br > 0 set botrow to "Governor"+SetGauge(localguage,1,30)+" "+halfmtr.
                                }}
                                  set hudopts[1][2] to "".
                                  set hudopts[1][1] to fl.
                                  if baylst[0] > 0 {
                                  set hudopts[1][3] to ":"+BayLst[BaySel][0]+":"+BayLst[BaySel][1]. 
                                  SET HDXT TO "BAY ".
                                  }
                              }
                            }else{ MKSConvCheck(fl,1,HudItem, hudtag).}.
                          }
                        }
                        IF HudItem = MksDrlTag{
                          if prtList[HudItem][hudtag][HudPrt]:hasmodule("usi_harvester"){
                            local t1 to prtList[HudItem][hudtag][HudPrt]:getmodule("usi_harvester").
                            set fl to t1:allfieldnames[1].
                            set hudopts[1][2] to "".
                            set hudopts[1][1] to "".
                            if GrpDspList2[HudItem][hudtag] = 4 set hudopts[1][3] to ":ACTIVE:".
                            if GrpDspList2[HudItem][hudtag] = 3 set hudopts[1][3] to ":NOT ACTIVE:".
                            MKSDrillCheck(fl,1,HudItem, hudtag).
                              IF BR=1 {
                                local aaa to getstatus(HudItem,hudtag,3,1).
                                IF AAA <> "                                    " {
                                  local localguage to (aaa:tonumber / 1)*100.
                                  if halfmtr = ""{ if br > 0 set botrow to "Governor"+SetGauge(localguage,1,widthlim-11).}
                                  else{
                                  IF ROWVAL = 1 { if br > 0 set botrow to "Governor"+SetGauge(localguage,1,30)+" "+halfmtr.}
                                }}
                                set hudopts[1][2] to "".
                                set hudopts[1][1] to "".
                              }
                          }
                        }
                      }
                      IF HudItem = ISRUTag{
                        set hudopts[1][2] to isruoptlst[ConvRSC]+":". 
                        set hudopts[1][3] to ToggleResConv(prtList[HudItem][hudtag][HudPrt],isruoptlst[ConvRSC],ConvRSC,2). 
                        set hudopts[1][1] to "Converter:"+ConvRSC+":".
                      }else{
                      IF HudItem = DrillTag{
                        set hudopts[1][1] to "Ore Rate".
                        set hudopts[1][2] to ":".
                        set HudOpts[1][3] to getstatus(HudItem,hudtag,2,1)+"        ".}}
                    }
                    else{
                    if DispInfo = 42 {
                      IF HudItem = CapTag {set botrow to "Stored Charge:"+GetFuelLeft(prtList[HudItem][hudtag],2).}
                      set HudOpts[1][3] to getstatus(HudItem,hudtag,1,1).
                    }
                    else{
                    if DispInfo = 43 {
                      IF P:HASMODULE("ModuleScienceConverter") set p to P:getmodule("ModuleScienceConverter").
                      IF HudItem = labTag {
                      IF BR=1 {iF P:HASfield("research") if br > 0 set botrow to "Research:"+p:GETFIELD("research") +"   Data:"+p:GETFIELD("Data")+"   Science:"+p:GETFIELD("Science"). set lcl to "WHT".}}
                      set HudOpts[1][3] to getstatus(HudItem,hudtag,1,1)+"        ".
                    }
                    else{
                    IF DispInfo =44{
                      LOCAL NOSLR TO 0.
                      FOR MD IN slrModAlt {
                        IF P:HASMODULE(MD) {
                          local tmp to getstatus(HudItem,hudtag,1,1).
                          set tmp to round(tmp:tonumber,2).
                          set HudOpts[1][1] to "Sun exposure:"+tmp.
                          SET NOSLR TO 1.
                          BREAK.
                        }
                      }
                      IF P:HASMODULE("ModuleResourceConverter") AND NOSLR = 1{clearrow(1).
                      set HudOpts[1][1] to modulelistRpt[huditem][statusdispnum]. PRINTLINE(). return.}
                    }
                    ELSE{}}}}
                  }
                  else{
                  if DispInfo <70 {
                    if DispInfo = 51 {
                      set HudOpts[1][1] to "".
                      set HudOpts[1][2] to "".
                      set HudOpts[1][3] to GetFuelLeft(prtList[HudItem][hudtag],2).
                    }
                    else{
                    if DispInfo = 52 {
                      set HudOpts[1][1] to "".
                      set HudOpts[1][2] to "".
                      if sas = false {set HudOpts[1][3] to getcolor(" SAS MDOE:OFF","RED").}else{set HudOpts[1][3] to getcolor(" SAS MODE:"+sasMode,"CYN").}
                      if steeringmanager:enabled = True set HudOpts[1][3] to getcolor("HEADING LOCKED","CYN"). 
                        if hudtag = 1 {
                        if apsel = 1 and axsel > 3 set axsel to 1.
                        if apsel = 2 IF axsel < 4 or axsel > 6 set axsel to 4.
                        if apsel = 3 and axsel < 7 set axsel to 7.
                          local l1 to " ".
                          local l2 to "               ".
                          local prfx to list(" ").
                          local sffx to list(" ").
                          for i in range(0,APaxis[0]) prfx:add(l1).
                          for i in range(0,APaxis[0]) sffx:add(l2).
                            for i in range (1,APaxis[0]){
                              if HdngSet[3][i] = 1 {
                                set prfx[i] to "*".
                                set sffx[i] to "*"+l2:substring(1,l2:length-1).
                              }
                            }
                          if br = 1{
                            set prfx[axsel] to ">".
                            set sffx[axsel] to "<"+l2:substring(1,l2:length-1).
                            SET HudOpts[1][1] TO "".
                            SET HudOpts[1][3] TO "        ".
                            if apsel = 1{
                              IF AXSEL = 1 SET HudOpts[1][2] TO "HEADING:"+ HdngSet[0][1].
                              IF AXSEL = 2 SET HudOpts[1][2] TO "PITCH:"  + HdngSet[0][2].
                              IF AXSEL = 3 SET HudOpts[1][2] TO "ROLL:"   + HdngSet[0][3].
                            }
                            if apsel = 2{
                              IF AXSEL = 4 SET HudOpts[1][2] TO "SPEED:"  + HdngSet[0][4].
                              IF AXSEL = 5 SET HudOpts[1][2] TO "ALT:"    + HdngSet[0][5].
                              IF AXSEL = 6 SET HudOpts[1][2] TO "V-SPD:"  + HdngSet[0][6].
                            }
                            if apsel = 3{
                              IF AXSEL = 7 SET HudOpts[1][2] TO "PITCH LIM:"+ HdngSet[0][7].
                              IF AXSEL = 8 SET HudOpts[1][2] TO "SPEED MIN:"+ HdngSet[0][8].
                              IF AXSEL = 9 SET HudOpts[1][2] TO "AOA LIM:"  + HdngSet[0][9].
                            }
                          }
                          if apsel = 1{
                            set botrow to " "+prfx[1]+       "HEADING:"+ HdngSet[0][1]+sffx[1].
                            set botrow to     botrow+prfx[2]+"PITCH:"  + HdngSet[0][2]+sffx[2].
                            set botrow to     botrow+prfx[3]+"ROLL:"   + HdngSet[0][3]+sffx[3].
                          }
                          if apsel = 2{
                            set botrow to  " "+prfx[4]+       "SPEED:"  + HdngSet[0][4]+sffx[4].
                            set botrow to      botrow+prfx[5]+"ALT:"    + HdngSet[0][5]+sffx[5].
                            set botrow to      botrow+prfx[6]+"V-SPD:"  + HdngSet[0][6]+sffx[6].
                          }
                           if apsel = 3{
                            set botrow to  " "+prfx[7]+       "PITCH LIM:"+ HdngSet[0][7]+sffx[7].
                            set botrow to      botrow+prfx[8]+"SPEED MIN:"+ HdngSet[0][8]+sffx[8].
                            set botrow to      botrow+prfx[9]+"AOA LIM:"  + HdngSet[0][9]+sffx[9].
                          }
                          if GrpDspList3[FLYTAG][1] <> 6{
                          LOCAL PR TO "                   ".
                          IF FlState = "Flight" {SET  ss to "         SIDESLIP:"+round(bearing_between(ship,srfprograde,ship:facing),1). if colorprint = 1 {set pr to "    ".}}
                          else{ set ss to "                ". if colorprint = 1 {set ss to "    ". set pr to "                ".}}
                          PRINTLINE(pr+"HEADING:"+ ROUND(compass_and_pitch_for()[0],0)+"         PITCH:"  + ROUND(compass_and_pitch_for()[1],0)+"         ROLL:"   + ROUND(roll_for(),0)+ss,0,13).
                          set ln14 to 2.
                          }
                        }ELSE{
                          if prttagList[HudItem][hudtag]:contains("TARGET") {
                            IF BR=1 {set botrow to "set target to:"+trglst[anttrgsel]+"           ". set ItmTrg to " SET TRGT ".set lcl to "CYN".}
                            else{if hastarget = True {set botrow to "Current target:"+target+"           ". set lcl to "WHT".}
                            else {set botrow to "WARNING: NO TARGET SET. SET A TARGET TO USE THIS MODE".set lcl to "RED". set ItmTrg to EmptyHud.}}
                          }
                        }
                    }
                    else{
                    if DispInfo = 61 {
                      if HudItem = habtag{
                        if alttag=1{set ItmTrg to " DPST RSC ".
                          IF BR=1{
                            if ship:resources[RscNum["MaterialKits"]]:capacity > 0 {
                            if rowval = 1 set botrow to RscList[RscNum["MaterialKits"]][1]+SetGauge(ship:resources[RscNum["MaterialKits"]]:amount/ship:resources[RscNum["MaterialKits"]]:capacity*100,1,widthlim-4-RscList[RscNum["MaterialKits"]][1]:length).
                            }else{if rowval = 1 set botrow to "No Material Kits Storage". set lcl to "RED".}
                          } 
                        }
                      }
                    }
                    else{
                    if DispInfo = 62 {
                    if HudItem = CntrlTag {
                      if ItmTrg = "  RETRACT " {
                        IF CSaxis[axsel] = "Pitch" {if rowval = 1  set botrow to  "Trim:"+round(Trim,0)+" Degrees        ".
                        }ELSE{if rowval = 1  set botrow to  "Deploy Angle:"+round(DplyAng,0)+" Degrees".
                        }}
                      }
                      if HudItem = RCSTag {if rowval = 1 set botrow to "Use Enter Button to Turn Axis Control off or on.". set lcl to "WHT".}
                    }
                    else{
                    }}}}
                  }
                  else{}}}}}
                 }
                  if botrow = bigempty2 set lcl to 0.      
                  if botrow:length > WidthLim set botrow to botrow:substring(0,WidthLim).
                  if printpause = 0 {if BOTPREV <> BOTROW PRINTLINE(botrow,lcl).  SET BOTPREV TO BOTROW.}else  SET BOTPREV TO "zz".
                 
              }else set forcerefresh to 1.
   }
   //#endregion 
   function ToggleGroup{//togglegroup(item number, tag number, option, auto).
      local parameter Inum, tagnum, optnin, auto is 0.
      if DbgLog > 0 {
        local nd to " MANUAL".
        if auto = 1 set nd to ":AUTO".
        if auto = 2 set nd to ":FROM QUEUE".
        log2file("TOGGLEGROUP:"+itemlist[Inum]+":"+prttaglist[Inum][tagnum]+nd). 
        if DbgLog > 1 log2file("       Inum:"+Inum+"-tagnum:"+tagnum+"-optnin:"+optnin+"-auto:"+auto ).
      }
        IF OPTNIN = 0{
          set AutoDspList[Inum][TagNum] to abs(AutoDspList[Inum][TagNum]).
          set AutoDspList[0][Inum][TagNum][0] to 0.
          UpdateAutoTriggers(autoRstList[Inum][TagNum],AutoDspList[Inum][TagNum],Inum,TagNum).
          PRINTQ:PUSH(REMOVESPECIAL(ItemListHUD[Inum]," ")+":"+Prttaglist[Inum][TagNum]+" DETECTION NOW ACTIVE"+"<sp>"+"GRN"). 
          if DbgLog > 0 {
            log2file("       UpdateAutoTriggers (autoRstList[Inum][TagNum],AutoDspList[Inum][TagNum],Inum,TagNum)." ).
            log2file("         "+"UpdateAutoTriggers ("+autoRstList[Inum][TagNum]+","+AutoDspList[Inum][TagNum]+","+Inum+","+TagNum+") ").
          }
          RETURN.
        }
        IF OPTNIN = -1{
          set OPTNIN to AutoTRGList[Inum][tagnum].
        }
      //#region toggle group settings
      set checktime to time:seconds.
      local MDL to modulelist[inum].
      local MDL2 to modulelistAlt[inum].
      local MDL3 to modulelistRPT[inum].
      local tagname to prttaglist[inum][tagnum].
      local pl to prtList[inum][tagnum].
      set pl to pl:sublist(1, pl:length).
      local opset to optnin.
      if opset > 3 set opset to 3. //add lines to all action lists to use 4& beyond manual entries.
      local optn3 to opset*3.
      local optn2 to optn3-1.
      local optn1 to optn3-2.
      local lightcheck to 0.
      local cmd to true.
      local evact to 0.
      //local ea1 to MDL[0].
      //local ea2 to MDL2[0]. 
      local fld to mdl3[0]. //field to get
      local op to mdl3[4]. //option for off
      global Module1 to MDL[optn1].
      global Event1On to MDL[optn2].
      global Event1Off to MDL[optn3].
      global Module2 to MDL2[optn1].
      global Event2On to MDL2[optn2].
      global Event2Off to MDL2[optn3].
      global COMMAND TO "".
      local p to  prtlist[Inum][tagnum][1].
      local PrintOverride to 0.
      local opout to 0.
      local ans to " ".
      local fl to "".
      local t to "".
      local printout to "".
      LOCAL PRFX TO "".
      set cnt to 0.
      local lco to 0.
      //#endregion
      if inum <> agtag and inum <> flyTag {
        LOCAL PL2 TO PL:COPY.
        for pt in pl2{
          if not pt:tostring:contains("tag="+tagname){
            if DbgLog > 0 log2file("        "+PT:TOSTRING+" REMOVED FOR TAG MISMATCH("+"tag="+tagname+")" ).
            set cnt to cnt+1.
            PL:REMOVE(PL:FIND(pt)).
          } //else break.
        }
      if cnt > pl2:length-1 OR PL:LENGTH = 0{
        if DbgLog > 0 log2file("      TAG REMOVED FOR TAG MISMATCH("+"tag="+tagname+")" ).
       return.
      }
      }
      if autoTRGList[0][inum][tagnum] < 0 return.
      if autoTRGList[0][inum][tagnum] > 0 and auto = 1 set evact to 4.
      //if not PrtListcur:contains(p) return.
      //#region TOGGLE CHECK
      if inum > 0{
        if debug > 0 and optnin < 4 PRINTLINE(optnin+"-"+Module1+"-"+Event1On+"-"+Event1Off,0,13).
        if DbgLog > 1 and optnin < 4 log2file("     MOD IN: Module1:"+optnin+"-Module1:"+Module1+"-Event1On:"+Event1On+"-Event1Off:"+Event1Off+" FLD:"+fld ).
        if inum = lighttag{
          SET PRFX TO "LIGHT ".
          IF P:hasmodule("modulecommand") AND AUTO <> 0 RETURN.
          if optnin = 1{
            local ccc to              getactions("Actions",lightModAlt,inum, tagnum,optnin,1,list("on"),list("off")).
            if  ccc[3] = 0 set ccc to getactions("Actions",lightModAlt,inum, tagnum,optnin,5,list("on"),list("off")).
            if  ccc[3] = 0 or ccc[0] = "moduleanimategeneric" {
              set ccc to getactions("Actions",lightModAlt,inum, tagnum,optnin,2,list("toggle light"),list("toggle light")).
              if ccc[3] > 0 {set ccc[3] to getactions("OnOff",lightModAlt,inum, tagnum,optnin,3,list("on"),list("off")).}
            }
            if  ccc[3] > 0 {
              clearev().
              SetTrgVars(CCC,-1).
              global tstccc2 to ccc.
              if ccc[0] = "moduleanimategeneric" {
                set Event1Off to Event1On. 
                set fld to " ".             
                if ccc[3] = 1 {set Event1Off to "". set Event2Off to "".}
                if ccc[3] = 2 {set Event1On to "". set Event2On to "".}
                set ans to " TOGGLED  ".  set PrintOverride to 3.
              }
            }
            IF AUTO = 2 SET PrintOverride TO -1.
          }
          if optnin = 3 and auto = 0{
            partcheck().
            local listout to list(AutoDspList, autovallist,itemlist,prttaglist, prtlist, autoRstList, AutoRscList ,AutoTRGList, MONITORID).
            WRITEJSON(listout, SubDirSV + autofileBAK).
            PRINTQ:PUSH(" SAVED BACKUP FILE       "+"<sp>"+"WHT"). 
            RETURN.
          }
        }
          else{
          if mks =1 {
          if inum = PWRTag {
            if optnin = 1 {
              if p:hasmodule("usi_converter"){
                set PrintOverride to 1.
                set forcerefresh to 1.
                set t to p:getmodule("usi_converter").
                set fl to t:allfieldnames[0]. 
                if baytrg[0] > 1{ 
                  set t to p:getmodulebyindex(baytrg[baysel][2]).
                  set fl to baytrg[baysel][0].
                  set evact to 3.
                }
                set module to module1.
                local ccc to getactions("Actions",PWRModALT,inum, tagnum,optnin,1,list("start", "activate"),list("stop", "deactivate")).          
                if ccc[3] = 3 or ccc[3] = 0{
                  if GrpDspList[Inum][tagnum] = 1{ 
                  PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED ON"+"<sp>"+"CYN").  
                    set ccc to getactions("Actions",PWRModALT,inum, tagnum,optnin,2,list("toggle"),list("zz")).
                    set GrpDspList[Inum][tagnum] to 2.
                    }
                  else{
                  if GrpDspList[Inum][tagnum] = 2{
                    PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED OFF"+"<sp>"+"RED"). 
                  set ccc to getactions("Actions",PWRModALT,inum, tagnum,optnin,2,list("zz"),list("toggle")).
                  }}
                }else{
                    if ccc[3] = 1  PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED ON"+"<sp>"+"CYN").                   
                    if ccc[3] = 2  PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED OFF"+"<sp>"+"RED"). 
                }
                set PrintOverride to -1.
               if  ccc[3] > 0 SetTrgVars(CCC,-1).
              }
            }else{
              if optnin = 3 and BTHD11:contains("TETHR"){
                local ccc to getactions("Actions",list("USI_InertialDampener"),inum, tagnum, optnin, 1,list("ground tether: on"),list("ground tether: off")).
                clearev().
                SetTrgVars(CCC).
              }
            }
          }
          else{
            if inum = MksDrlTag {
              IF OPTNIN = 1{
                set GrpDspList2[Inum][tagnum] to 3.
              }
              if optnin = 2 {
                  if getactions("OnOff",AnimModAlt,inum, tagnum,1,1,list("retract")) <> 0 {
                  if prtlist[MksDrlTag][tagnum][1]:hasmodule("usi_harvester"){
                    set forcerefresh to 1.
                    set t to prtlist[MksDrlTag][tagnum][1]:getmodule("usi_harvester").
                    set fl to t:allfieldnames[1].
                    //set fl2 to getEvAct(pl[0],"usi_harvester",t:getfield(fl+" rate"),30).
                        local ccc to getactions("Actions",list("usi_harvester"),inum, tagnum, optnin, 0,list("start","activate"),list("stop","deactivate")).
                        if ccc[3] <> 3 {
                        if ccc[3] = 1  PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED ON"+"<sp>"+"CYN").                   
                        if ccc[3] = 2  PRINTQ:PUSH(" "+prtTagList[INUM][tagnum]+" TURNED OFF"+"<sp>"+"RED"). 
                        }else{
                      if GrpDspList2[Inum][tagnum] = 3{
                        set ccc to getactions("Actions",MksDrlModAlt,inum, tagnum,optnin,2,list("activate","toggle"),list("ZZ")).
                        set GrpDspList2[Inum][tagnum] to 4.
                        }
                      else{
                      if GrpDspList2[Inum][tagnum] = 4{
                        set ccc to getactions("Actions",MksDrlModAlt,inum, tagnum,optnin,2,list("zz"),list("deactivate","toggle")).
                        set GrpDspList2[Inum][tagnum] to 3.
                      }}
                    }
                  if  ccc[3] > 0 {clearev(). SetTrgVars(CCC,-1).}
                  }
                }else{                  
                   PRINTQ:PUSH(" DRILL NOT DEPLOYED! DEPLOYING AND STARTING"+"<sp>"+"ORN").
                      ActionQNew:ADD(List(TIME:SECONDS,inum,tagnum,1)). 
                      ActionQNew:ADD(List(TIME:SECONDS+5,inum,tagnum,2)). 
                }
                set PrintOverride to -1.
              }
            }
            else{if inum = habtag {set forcerefresh to 1.}}
          }
        }// stop putting else line here.
          if inum = ENGtag { 
            IF optnin = 1 {
              clearev().
              local lon to list("on", "activate").
              local loff to list("off","shutdown").
              local Elst to engModAlt.
              if p:hassuffix("modes") if P:modes:length > 1 {if not P:primarymode set Elst to list("MultiModeEngine").}
              if p:hassuffix("ignition"){if p:ignition = false set loff to list(""). else set lon to list("").}           
              local ccc to getactions("Actions",Elst,inum, tagnum,optnin,3,lon,loff).
              if  ccc[3] > 0 SetTrgVars(CCC,-1).
            }
            IF optnin = 3 {set fld to "GIMBAL". set op to "False".}
          }//}
          else{
          if inum = dcptag { 
            IF optnin = 1{
              local ct to 0.
              for pt in pl {
                for md in DcpModAlt{
                  if pt:hasmodule(md){set ct to ct+1.
                    if ct = 1 set module1 to md. 
                    if ct = 2 set module2 to md.
                  }
                }
              }
               if p:hasmodule(Module1){
                if p:getmodule(Module1):hasEVENT("jettison heat shield"){set t to p:getmodulebyindex(0). set evact to 3.}
              }
            }
            if optnin = 3{
                local ccc to GetActions(5,AnimModAlt,inum, tagnum,optnin,3,list("inflate", "deflate", "deploy")).
                if  ccc[3] > 0{SetTrgVars(CCC).}
            }
          if pl[0]:hasmodule("moduledecouple") or pl[0]:hasmodule("ModuleAnchoredDecoupler") if pl[0]:hassuffix("ISDECOUPLED")  if pl[0]:ISDECOUPLED = True { PRINTQ:PUSH("ALREADY DECOUPLED      "+"<sp>"+"RED"). return.}.
          }
          else{
          if inum = CntrlTag {
            if  pl[0]:hasmodule("ModuleAeroSurface")set module1 to "ModuleAeroSurface".
            if optnin = 2 {set Event1On to "toggle "+CSaxis[axsel]+" control".set Event2On to Event1On. set fld to " ". set op to "".}
            if optnin = 3 {
            for m in CntrlModAlt {
              for pt in pl {
              getEvAct(pt,m,"Deploy Angle",40, flist[FSel]).
              }
            }
              return.
            }
            if optnin = 4 {
            for m in CntrlModAlt {
              for pt in pl {
               getEvAct(pt,m,"Deploy Angle",40, 0-trim).
              }
            }
              return.
            }
          }
          else{
          if inum = WMGRtag {
                if optnin = 1 {getEvAct(pl[0],"MissileFire","fire missile",20). set PrintOverride to -1.  PRINTLINE(tagname+ " FIRING" ,"RED"). return.}
                if optnin = 2 and Radartag > 0 and BTHD10 = "NEXT TRGT "{
                  if getEvAct(pl[0],"ModuleRadar","target next",20) PRINTQ:PUSH("RADAR TARGET CYCLED    "+"<sp>"+2). 
                  return.
                }
                if optnin = 3 {
                  if CMtag > 0 and BTHD11 <> "NEXT TEAM " for cm in cmlist {if getEvAct(cm,"CMDropper","fire countermeasure",20) PRINTLINE("COUNTERMEASURES FIRED " ,"RED").} 
                  if BTHD11 = "NEXT TEAM " and auto = 0  if getEvAct(pl[0],"MissileFire","next team",20)PRINTQ:PUSH("Team changed to "+pl[0]:getmodule("MissileFire"):getfield("team")+"<sp>"+2). set PrintOverride to -1.
                  RETURN.
                }
              }
          else{
          if inum = BDPtag {
              IF pl[0]:hasmodule("BDModulePilotAI"){ set fl to pl[0]:getmodule("BDModulePilotAI").
                if optnin = 2 AND pl[0]:getmodule("BDModulePilotAI"):hasFIELD("standby mode"){ 
                  SET forcerefresh TO 1.
                  IF fl:GETFIELD("standby mode") = False {
                    fl:SETFIELD("standby mode", True). PRINTQ:PUSH("STANDBY MODE ON "+"<sp>"+2).  
                    SET GrpDspList2[Inum][tagnum] TO 4. return.}
                  ELSE{
                    fl:SETFIELD("standby mode", False). PRINTQ:PUSH("STANDBY MODE OFF "+"<sp>"+1).  
                    SET GrpDspList2[Inum][tagnum] TO 3. return.}
                }
                if optnin = 3 AND fl:hasFIELD("unclamp tuning "){ SET forcerefresh TO 1.
                  IF fl:GETFIELD("unclamp tuning ") = False {
                    fl:SETFIELD("unclamp tuning ", True).  PRINTQ:PUSH( "TUNING UNCLAMPED "+"<sp>"+1). SET TUNECLAMP TO 0. SET GrpDspList3[Inum][tagnum] TO 6. return.}ELSE{
                    fl:SETFIELD("unclamp tuning ", False). PRINTQ:PUSH( "TUNING CLAMPED "+"<sp>"+2). SET TUNECLAMP TO 1. SET GrpDspList3[Inum][tagnum] TO 5. return.}
                }
              }
            }
          else{
          if inum = AGTag {
            if evact <> 4{
              IF optnin = 1 {
                set opout to 1.
                if tagnum = 1 {  toggle ag1 . if ag1  = true SET opout TO 2.}else{
                if tagnum = 2 {  toggle ag2 . if ag2  = true SET opout TO 2.}else{
                if tagnum = 3 {  toggle ag3 . if ag3  = true SET opout TO 2.}else{
                if tagnum = 4 {  toggle ag4 . if ag4  = true SET opout TO 2.}else{
                if tagnum = 5 {  toggle ag5 . if ag5  = true SET opout TO 2.}else{
                if tagnum = 6 {  toggle ag6 . if ag6  = true SET opout TO 2.}else{
                if tagnum = 7 {  toggle ag7 . if ag7  = true SET opout TO 2.}else{
                if tagnum = 8 {  toggle ag8 . if ag8  = true SET opout TO 2.}else{
                if tagnum = 9 {  toggle ag9 . if ag9  = true SET opout TO 2.}else{
                if tagnum = 10 { toggle ag10. if ag10 = true SET opout TO 2.}else{
                if tagnum = 11 {
                  IF throttle < 1 SET ship:control:pilotmainthrottle TO 1. ELSE SET ship:control:pilotmainthrottle TO 0.
                  if THROTTLE > 0 SET opout TO 2.}else{
                if tagnum = 12 { 
                  IF RCS = False RCS ON. ELSE RCS OFF.
                  if RCS = False SET opout TO 2.
                }
                else{return.}}}}}}}}}}}}
                SET GrpDspList[Inum][tagnum] TO opout.
                PRINTQ:PUSH( tagname+ " "+" TRIGGERED "+"<sp>"+lightcheck). 
                IF AutoDspList[0][INUM][TAGNUM]:LENGTH > 1 LINKCHECK(inum, tagnum).
                IF PRINTQ:LENGTH > 0 and printpause = 0 PrintTheQ().
                return.
              }
              IF OPTNIN = 2 {
                  if tagnum = 1 {
                    if RunAuto = 1 OR RUNAUTO = 2 {set RunAuto to 3. PRINTQ:PUSH(" AUTO TRIGGERS DISABLED "+"<sp>"+"RED"). set PrintOverride to -1.}
                    ELSE IF RUNAUTO = 3 {
                      IF SHIP:status = "PRELAUNCH" {SET RUNAUTO TO 2.  PRINTQ:PUSH(" AUTO TRIGGERS SET TO PRELAUNCH "+"<sp>"+"YLW"). set PrintOverride to -1.}
                      ELSE IF IsPayload[0] = 1 AND IsPayload[1] <> core:part {SET RunAuto TO 0. PRINTQ:PUSH(" AUTO TRIGGERS SET TO PAYLOAD PART "+"<sp>"+"YLW"). set PrintOverride to -1.}
                      ELSE {set RunAuto to 1. PRINTQ:PUSH(" AUTO TRIGGERS ENABLED "+"<sp>"+"CYN"). set PrintOverride to -1.}
                    }
                  }
                  if rowsel = 1{
                    if tagnum = 2 {
                      set refreshRateSlow to CHANGESEL(10,refreshRateSlow ,"+").
                      PRINTQ:PUSH(" HUD REFRESH RATE SET TO "+refreshRateSlow+"<sp>"+"WHT"). set PrintOverride to -1.
                      set RFSBAak to refreshRateSlow.
                    }
                    if tagnum = 10 {
                      set dbglog to CHANGESEL(4,dbglog ,"+").
                      IF dbglog > 3 SET dbglog TO 0.
                      LOCAL ZZ TO " ON". IF dbglog = 0 SET ZZ TO " OFF". if dbglog = 2 set ZZ to " VERBOSE".  if dbglog = 3 set ZZ to " OVERKLL".
                      PRINTQ:PUSH(" LOGGING SET TO "+ZZ+"<sp>"+"WHT"). set PrintOverride to -1.
                    }
                  }
                IF PRINTQ:LENGTH > 0 and printpause = 0 PrintTheQ().
                RETURN.
              }
              if optnin = 3 {
                if TAGNUM = 1{
                  PRINTQ:PUSH(" LISTING AUTO SETTINGS"+"<sp>"+"CYN"). set PrintOverride to -1.
                  listautosettings().
                }
                if tagnum = 2{
                  set refreshRateFast to CHANGESEL(10,refreshRateFast ,"+").
                  PRINTQ:PUSH(" INFO REFRESH RATE SET TO "+refreshRateFast+"<sp>"+"WHT"). set PrintOverride to -1.
                }
                if tagnum = 10 {
                  set DEBUG to CHANGESEL(2,DEBUG ,"+").
                  if debug> 1 SET DEBUG TO 0.
                  LOCAL ZZ TO " ON". IF DEBUG = 0 SET ZZ TO " OFF".
                  PRINTQ:PUSH(" DEBUG SET TO "+ZZ+"<sp>"+"WHT"). set PrintOverride to -1.
                }
              }
            }
          }
          else{
          if inum = FlyTag {
            if evact <> 4{
              set opout to 2.
              local strst to StrLock.
              local trgsas to 1.
              if tagnum > 1{
                if SHIP:VELOCITY:SURFACE:MAG<1 and tagnum < 4 {set trgsas to 0.}
                unlock steering.
                if sasmode =  Removespecial(prtTagList[Flytag][tagnum]," ") AND SAS = True set opout to 1.
                if opout = 1 {sas off. PRINTQ:PUSH(" SAS SET TO:OFF"+"<sp>"+"GRN"). set PrintOverride to -1.
                  set StrLock to 0.
                }
                else{
                  LOCAL SSKP TO 0.
                  if trgsas = 1{
                    if prttagList[INUM][TAGNUM]:contains("TARGET") {
                      if hastarget <> True {PRINTQ:PUSH("NO TARGET SET. SET A TARGET TO USE THIS MODE"+"<sp>"+"RED"). SET SSKP TO 1.}
                    }
                    IF SSKP = 0{
                      SAS ON. wait 0.1. 
                      set sasmode to Removespecial(prtTagList[Flytag][tagnum]," ").
                      PRINTQ:PUSH(" SAS SET TO:"+sasMode+"<sp>"+"CYN").  set PrintOverride to -1.
                      set StrLock to tagnum.
                    }
                  }
                }
              }
              else{
                if rowval = 1 {           

                  if optnin = 1{
                    set HdngSet[3][axsel] TO CHANGESEL(2,HdngSet[3][axsel] ,"+").
                  }
                  if optnin = 2 {
                    if zop = 1{
                    if axsel = 1 set HdngSet[0][1] to ROUND(compass_and_pitch_for()[0],0).
                    if axsel = 2 set HdngSet[0][2] to ROUND(compass_and_pitch_for()[1],0). 
                    if axsel = 3 set HdngSet[0][3] to ROUND(roll_for(),0).
                    if axsel = 4 set HdngSet[0][4] to ROUND(SHIP:VELOCITY:SURFACE:MAG,0).
                    if axsel = 5 set HdngSet[0][5] to ROUND(ship:altitude,0).
                    if axsel = 6 set HdngSet[0][6] to ROUND(ship:VERTICALSPEED,0).
                    set zop to 2.
                    }
                    else{
                    if axsel = 1 set HdngSet[0][1] to 0.
                    if axsel = 2 set HdngSet[0][2] to 0.
                    if axsel = 3 set HdngSet[0][3] to 0.
                    if axsel = 4 set HdngSet[0][4] to 0.
                    if axsel = 5 set HdngSet[0][5] to 0.
                    if axsel = 6 set HdngSet[0][6] to 0.
                    if axsel = 7 set HdngSet[0][7] to 0.
                    if axsel = 8 set HdngSet[0][8] to 0.
                    if axsel = 9 set HdngSet[0][9] to 0.
                    set zop to 1.
                    }
                  }
                }else{
                  if optnin = 1{
                    if GrpDspList[Inum][tagnum] = 1 {
                      set opout to 2.
                      sas off.
                      //LOCK STEERING TO HEADING(HdngSet[0][1]+flyadj[1],HdngSet[0][2]+flyadj[2]+plimadj,HdngSet[0][3]+flyadj[3]).
                      LOCK STEERING TO HEADING(HdngSet[0][1]+flyadj[1],HdngSet[0][2]+flyadj[2],HdngSet[0][3]+flyadj[3]).
                      set StrLock to 1.
                      PRINTQ:PUSH(" HEADING LOCKED"+"<sp>"+"CYN"). set PrintOverride to -1.
                    }
                    else{
                      set opout to 1.
                      unlock steering. set strlock to 0.
                      PRINTQ:PUSH(" STEERING UNLOCKED"+"<sp>"+"ORN"). set PrintOverride to -1.
                    } 
                  }
                  if optnin = 2 {
                    set HdngSet[0][1] to ROUND(compass_and_pitch_for()[0],0).
                    set HdngSet[0][2] to ROUND(compass_and_pitch_for()[1],0). 
                    set HdngSet[0][3] to ROUND(roll_for(),0).
                    set HdngSet[0][4] to ROUND(SHIP:VELOCITY:SURFACE:MAG,0).
                    set HdngSet[0][5] to ROUND(ship:altitude,0).
                    set HdngSet[0][6] to ROUND(ship:VERTICALSPEED,0).
                  }
                  if optnin = 3{
                    if GrpDspList3[Inum][tagnum] = 5 {set GrpDspList3[Inum][tagnum] to 6. PRINTQ:PUSH(" HEADING WILL ALWAYS SHOW"+"<sp>"+"WHT"). set PrintOverride to -1.}
                    else{                             set GrpDspList3[Inum][tagnum] to 5. PRINTQ:PUSH(" HEADING WILL SHOW ON THIS PAGE"+"<sp>"+"GRN"). set PrintOverride to -1.}
                    SET forcerefresh TO 1.
                    return.
                  }



                }
              }
              SET GrpDspList[Inum][tagnum] TO opout. 
              if strst > 0 {if steeringmanager:enabled = false set GrpDspList[Inum][strst] to 1. else set GrpDspList[Inum][strst] to 2.}
              return.
            }
          }
          else{
          if inum = sciTag {
            SET LCO TO 1.
            if optnin = 1{
              if getactions("OnOff",SciModAlt,inum, tagnum,1,1,list("review","reset")) <> 0  and auto = 0{
                set printout to " DELETED               ".
                set evact to 2.
                local ccc to getactions("Actions",SciModAlt, inum, tagnum,optnin,evact, list("delete","discard", "reset")). 
                IF P:HASMODULE("SCANSAT") set ccc to getactions("Actions",list("SCANexperiment"), inum, tagnum,optnin,1, list("delete","discard","review")).  
                SetTrgVars(CCC).
                set forcerefresh to 2.
              }else{
                local wt to 0.
                set evact to 1.
                if auto < 2 {
                  local DDD to getactions("Actions",SciModAlt, inum, tagnum,optnin,EVACT, list("deploy","extend","open"),list("crew report")). //l1 = check to make sure deployed optns, l2 = if has sci action and unrelated deploy optn
                  if DDD[3] <> 0 {
                    set module1 to DDD[0].
                    if ddd[1] <> "" set Event1On to DDD[1]. else set Event1On to DDD[2].
                    set fld to " ".
                    if ddd[3] = 1{
                      set wt to 1.
                      ActionQNew:ADD(List(TIME:SECONDS+5,inum,tagnum,optnin)). 
                      ActionQNew:ADD(List(TIME:SECONDS+9,inum,tagnum,2)). 
                      PRINTQ:PUSH("Deploying! Experiment will run in 5 seconds then retract."+"<sp>"+"WHT").
                      set PrintOverride to -1.
                    }
                  }
                  }
                  if wt = 0{
                      local ccc to getactions("Actions",SciModAlt,inum, tagnum, optnin, 3,SciRun).
                      clearev().
                      SetTrgVars(CCC).
                  }
              }
              set scipart to 1.
              }
            if optnin = 2{
              set evact to 1.
              local ccc to getactions("Actions",SciModAlt, inum, tagnum,optnin,2, list("delete","discard","review","reset")).
              if auto = 2 set ccc[3] to 0.
              if  ccc[3] <> 0{
                if pl[0]:getmodule(ccc[0]):Hasdata{
                  pl[0]:getmodule(ccc[0]):transmit. 
                  LOCAL CNN TO 1.
                  if rtech <> 0 {if not rtech:hasKSCconnection(ship) set cnn to 0.} ELSE {IF HOMECONNECTION = "" SET CNN TO 0.}
                  if cnn = 1 PRINTQ:PUSH(" TRANSMITTING SCIENCE"+"<sp>"+"WHT"). else PRINTQ:PUSH(" NO CONNECTION"+"<sp>"+"ORN"). 
                  set PrintOverride to -1.
                } 
              }else{
                set ccc to getactions("Actions",AnimModAlt,inum, tagnum,optnin,evact,list("deploy","extend","open"),list("retract","close")). 
                clearev(). 
                SetTrgVars(CCC).
              }
            }
            if optnin = 3{
              set evact to 2. 
              if pl[0]:hasmodule("ModuleScienceContainer"){
                local ccc to GetActions("Actions",list("ModuleScienceContainer"),inum, tagnum,optnin,3,list("collect")).
                if  ccc[3] <> 0{
                  clearev().
                  SetTrgVars(CCC).
                  PRINTQ:PUSH(" SCIENCE COLLECTED"+"<sp>"+"YLW"). set PrintOverride to -1.
                }
              }
              if GetActions(1,SciModAlt,inum, tagnum,3,1,list("reset"), list("reset")) <> 0{
                local ccc to getactions("Actions",SciModAlt, inum, tagnum, 3, 1, list("reset")).
                if  ccc[3] <> 0{
                  set botrow to bigempty2.
                  set printout to " RESET".
                  clearev().
                  SetTrgVars(CCC). 
                }
              }
              if pl[0]:hasmodule("scansat"){
                local ccc to  getactions("Actions",list("scansat"),inum, tagnum,2,1,list("start"),list("stop")).
                SetTrgVars(CCC).
              }

            }
            if optnin = 4{
              for md in sciModAlt{
                if Pl[0]:hasmodule(md){
                  local pm to pl[0]:GetModule(md).
                  local sc to pm:alleventnames.
                  if sc:length = 0 {set sc to pm:allactionnames. set evact to 2.}
                  if sc:length > 0{
                    set event1on to sc[scipart-1]. set event2on to "".
                    set event1off to sc[scipart-1]. set event2off to "".
                    set module1 to md. set module2 to "".
                    PRINTQ:PUSH("EXPERIMENT "+event1on+" RUN"+"<sp>"+"CYN").
                    set PrintOverride to -1.
                    break.
                  }else{return.}
                }
              } set scipart to 1.
            }
          }
          else{
          if inum = baytag{if pl[0]:hasmodule("Hangar") set module to module2.}
          else{
          if inum = geartag{
            IF pl[0]:hasmodule(module1) {
              set evact to 2.
              if rowval = 0 or auto = 1{
                if optnin = 3 {set fld to "steering". set op to "False". set lco to 1.}
              }
              else{
              if rowval = 1 and auto = 0{
                set lco to 1.
                set gearop to 1.
                if optnin = 1 set gearop to 1.
                if optnin = 2 set gearop to 7.
                if optnin = 3 set gearop to 3.    
                if optnin = 4 set gearop to 5.          
                  set module1 to GearModLst[0][gearop].
                  set Event1On to GearModLst[1][gearop].
                  set Event1Off to GearModLst[2][gearop].
                  //set ea1 to GearModLst[4][gearop].
                  local ev to "".
                  local pev to "".
                  set fld to " ".
                  if pl[0]:hasmodule(module1) if pl[0]:getmodule(module1):hasfield(GearModLst[3][gearop]){set ev to 2.}else{set ev to 1.}
                  local PUIDPrev to "".
                  for pt in pl{
                    if pt:hasmodule(module1){
                      local pm to pt:getmodule(module1).
                      if pm:hasfield(GearModLst[3][gearop]){set pev to 2.}else{set pev to 1.}
                      if  pt:symmetrycount > 1{for sym in range (1,pt:symmetrycount){if  pt:SYMMETRYPARTNER(sym):uid = PUIDPrev set pev to 3.}}
                      if GearModLst[4][gearop] = "Event" {
                        if ev = pev {if PM:hasevent(Event1Off){PM:doevent(Event1Off).}
                            else{ if PM:hasevent(Event1On) PM:doevent(Event1On).}
                        }
                      }
                      else{
                        if GearModLst[4][gearop] = "Action" {
                          if ev = pev{ if PM:hasaction(Event1Off){PM:doaction(Event1Off,True).}
                                else{if PM:hasaction(Event1On) PM:doaction(Event1On,True).}
                          }
                        }
                      else{
                        if GearModLst[4][gearop] = "Field" {
                          if PM:hasfield(GearModLst[3][gearop]) {
                            if PM:getFIELD(GearModLst[3][gearop]) = False set fl to True. else set fl to False.
                            if ev = pev {PM:SETFIELD(GearModLst[3][gearop], fl).}
                          }
                        }
                      }}

                      if pev < 3 set PUIDPrev to p:uid.
                    }
                  }
                  IF AutoDspList[0][INUM][TAGNUM]:LENGTH > 1 LINKCHECK(inum, tagnum).
                  SetHudOptn(ev, optnin, inum, tagnum).
                  LGHTCHECK(tagname).
                  return.
              }
              }
            }
          IF pl[0]:hasmodule(module2) set fld to " ".
          }
          else{
          if inum = anttag{
            if optnin = 1{
            if pl[0]:hasmodule("ModuleAnimateGeneric") and not pl[0]:hasmodule("ModuleDeployableAntenna"){
              local ccc to getactions("Actions",list("ModuleAnimateGeneric"),inum, tagnum,optnin,1,list("extend"),list("retract")). 
                if  ccc[3] <> 0{SetTrgVars(CCC). SET OPTNIN TO 2.}
              }
            }
          }
          ELSE{
          if inum = RBTTag{
            if pl[0]:hasmodule("ModuleRoboticController"){
              local ccc to "".
              set fld to " ".
              if optnin = 1 {set ccc to getactions("Actions",list("ModuleRoboticController"),inum, tagnum,optnin,2,list("toggle play")). set ANS to " PLAY TOGGLED".}
              if optnin = 2 {set ccc to getactions("Actions",list("ModuleRoboticController"),inum, tagnum,optnin,2,list("toggle loop mode")). set ANS to "LOOP MODE TOGGLED".}
              if optnin = 3 {
                IF BTHD11 <> "ENAB/DISAB" {set ccc to getactions("Actions",list("ModuleRoboticController"),inum, tagnum,optnin,2,list("toggle direction")). set ANS to "DIRECTION TOGGLED".}
                ELSE                      {set ccc to getactions("Actions",list("ModuleRoboticController"),inum, tagnum,optnin,2,list("toggle controller enabled")). set ANS to "ENABLE TOGGLED".}
              }
              if  ccc[3] > 0{
                clearev().
                SetTrgVars(CCC,-1).
                set lightcheck to 1.
                 SET PrintOverride TO 1.
              }
            }
              else{
              local count to 0.
              for MD in RBTModLst[0]{
                if pl[0]:modules:contains(MD) {
                  set module1 to MD. set module2 to "".
                  IF OPTNIN = 1 {
                    set fld to " ".
                    local ccc to getactions("Actions",list(MD),inum, tagnum,optnin,2,list("toggle")).
                    if  ccc[3] > 0{
                      clearev().
                      SetTrgVars(CCC,-1).
                      set lightcheck to 1.
                    }
                  }
                  break.
                }
                set count to count+1.
              }
              IF OPTNIN = 1{for pt in pl {getEvAct(pt,module1,"disengage servo lock",20).} SET forcerefresh TO 2.}
            }
          }
          else{
            if inum = labtag{
              if optnin = 3{set evact to 2. 
                local ccc to GetActions(5,list("ModuleScienceContainer"),inum, tagnum,optnin,3,list("collect")).
                if  ccc[3] <> 0{
                  SetTrgVars(CCC).
                }
              }
            }            
            else{
              IF INUM = DockTAG {
                IF optnin = 1{
                   if P:hassuffix("STATE") IF P:STATE ="DISABLED" {
                    if getactions("OnOff",AnimModAlt ,inum, tagnum,1,1,list("OPEN"),list("CLOSE")) <> 0 {
                      ActionQNew:ADD(List(TIME:SECONDS,inum,tagnum,2)).
                      PRINTQ:PUSH(tagname+ " NOT DEPLOYED. DEPLOYING"+"<sp>"+"YLW").
                      RETURN.
                    }
                     }
                  if P:hassuffix("HASPARTNER") IF P:HASPARTNER <> TRUE {PRINTQ:PUSH(tagname+ " NOT DOCKED"+"<sp>"+"ORN"). RETURN.}
                }
                if optnin = 2{
                  local l1 to list("open","close","toggle"). local l2 to list("open","close","toggle").
                  if P:hassuffix("STATE") IF P:STATE ="DISABLED" set l2 to list(""). else set l1 to list(""). 
                  local ccc to getactions("Actions",AnimModAlt,inum, tagnum,optnin,3,l1,l2).
                  if  ccc[3] <> 0{
                    clearev().
                    SetTrgVars(CCC).
                  }
                }
              }ELSE{
                         
              if DbgLog > 0 log2file("    "+Pl[0]:TOSTRING+"    NO TAG MATCH!!!!" ).}}}}}}}}}}}}}}}
          //#endregion 
          //#region TRIGGER
          if module2   = module1   set module2  to "". 
          if Event2On  = Event1On  set Event2On  to "". 
          if Event2Off = Event1Off set Event2Off to "".
          local ccc to               getactions("Actions",list(module1,module2),inum, tagnum,optnin,1,list(Event1On,Event2On),list(Event1Off,Event2Off)).
          if  ccc[3] = 0 {
            if fld = " "  set ccc to  getactions("Actions",list(module1,module2),inum, tagnum,optnin,2,list(Event1On,Event2On),list(Event1Off,Event2Off)).
            else          set ccc to  getactions("Actions",list(module1,module2),inum, tagnum,optnin,0,list(Event1On,Event2On),list(Event1Off,Event2Off)).
            }

          if defined(ccc) {
            SetTrgVars(CCC,-1,evact).
            set module to ccc[0]. 
            set lightcheck to ccc[3].
            if lightcheck = 1 {set OPout to optn2. set command to ccc[1].}
            if lightcheck = 2 {set OPout to optn3. set command to ccc[2].}
          }
          if fld <>" " and evact <> 1{
            local yn to 0. 
            local ddd to getactions("Actions",list(module1,module2),inum, tagnum,optnin,4,list(fld)).
            set lightcheck to ddd[3].
            set module to ddd[0]. 
            set fld to ddd[1]. 
            LOCAL FldVal to ddd[2]. 
            if FldVal = op{set command to Event1On. set OPout to optn2. set lightcheck to 1.}
              else{        set command to Event1Off. set OPout to optn3. set lightcheck to 2. }
              if DbgLog > 0 log2file("     FIELD CHECK: "+module+"-"+command+"-"+fld+":"+fldval+"-"+op).
            }
            if OPout > 0 {
                if lightcheck = 1 or lightcheck = 3 set cmd to True.
                if lightcheck = 2 set cmd to False.
              set dbgtrk to "0".
              local lc to 0.
                  if autoTRGList[0][inum][tagnum] > 0 and auto = 1 set evact to 4.
                  if evact < 4{
                    for pt in pl {
                      if PrtListcur:contains(pt) AND SHIP:PARTS:contains(pt){
                        if evact = 1 {
                            if getEvAct(PT,module,command,1){
                              if INUM = RBTTag and autoRstList[0][0][tagnum] > 0 and optnin =1 and not pl[0]:hasmodule("ModuleRoboticController"){
                                ActionQNew:ADD(List(TIME:SECONDS+autoRstList[0][0][tagnum],inum,tagnum,2)).
                                }   //QUEUE FOR ROBOT LOCK
                              if inum = dcptag and optnin = 1 {if not tagname:contains("Payload") AND not tagname[0]:contains("Z0"){DcpPrtXtra(pt).}}
                              pt:GETMODULE(module):doevent(command). 
                            }
                          }
                        else{
                        if evact = 2 {
                            if getEvAct(PT,module,command,2){
                              if INUM = RBTTag and autoRstList[0][0][tagnum] > 0 and optnin =1 and not pl[0]:hasmodule("ModuleRoboticController"){
                                ActionQNew:ADD(List(TIME:SECONDS+autoRstList[0][0][tagnum],inum,tagnum,2)).
                              } //QUEUE FOR ROBOT LOCK
                              if inum = dcptag and optnin = 1{if not tagname:contains("Payload") AND not tagname[0]:contains("Z0"){DcpPrtXtra(pt).}}
                               pt:GETMODULE(module):doaction(command,cmd).
                            }
                          }
                        else{
                        if evact = 3 {getEvAct(PT,module,command,10).set dbgtrk to "3".}}}
                        wait 0.001.
                      }
                    }
                    if inum <> lighttag and pl[0] <> ship:rootpart and lco = 0 set lc to LGHTCHECK(tagname).
                  }
                  IF evact = 4 SET PrintOverride TO -1.
                  if printout = "" set printout to modulelistRPT[inum][OPout].
                  if lc = 1 and pl[0] <> ship:rootpart set printout to printout+" AND LIGHTS TOGGLED".
                  local lcl to lightcheck.
                  if PrintOverride = 0 {set lout to PRFX+tagname+ " "+ printout.} else{ set lout to  PRFX+tagname+ " "+ ans. set lcl to PrintOverride.}
                  IF PrintOverride > -1 PRINTQ:PUSH(lout+"<sp>"+LCL).  
                  if debug > 0 PRINTLINE(module+"-"+command+"-"+opout+"-"+evact+"-"+cmd+"-"+fld+"-"+op,0,14).
                  if DbgLog > 0{
                    local EVTXT TO "      ACTION OUT:".
                    IF evact = 1 SET EVTXT TO "     EVENT  OUT:".
                    log2file(EVTXT+module+":"+command+" - "+modulelistRPT[inum][OPout]+" - FIELD:"+fld+" - FIELDOFF:"+op ).
                  }
                  IF AutoDspList[0][INUM][TAGNUM]:LENGTH > 1 LINKCHECK(inum, tagnum).
                  SetHudOptn(lightcheck, optnin, inum, tagnum).
            }
            ELSE{
              if debug > 0 PRINTLINE(module1+"-"+module2+"-"+command+"-"+evact+"-"+LIGHTCHECK+"-"+fld+"-"+op+" NOTRG ",0,14).
              if DbgLog > 0 and evact <> 4 log2file("     MOD OUT: "+module1+"-"+module2+"-"+command+"-"+evact+"-"+LIGHTCHECK+"-"+fld+"-"+op+" NOTRG " ).
              IF PrintOverride > -1 and evact <> 4 and auto <> 1 {
              PRINTQ:PUSH(PRFX+tagname+ " "+ printout+" TRIGGER FAILED"+"<sp>"+"ORN").
              if DbgLog > 0 log2file(PRFX+tagname+ " "+ printout+" TRIGGER FAILED" ).
            }
            }
          //#endregion 
          }
            IF evact = 4 and auto = 1 {
              ActionQNew:ADD(List(TIME:SECONDS+AutoTRGList[0][inum][tagnum],inum,tagnum,optnin)). //ActionQueue2[AutoTRGList[0][inum][tagnum]]:ADD(List(inum,tagnum,optnin)). 
              PRINTQ:PUSH(tagname+" "+autoTRGList[0][inum][tagnum]+" SECOND DELAY"+"<sp>"+"YLW").
              if DbgLog > 0 log2file("     "+tagname+" "+autoTRGList[0][inum][tagnum]+" SECOND DELAY").
              IF PRINTQ:LENGTH > 0 and printpause = 0 PrintTheQ().

              Return.
            }
          IF PRINTQ:LENGTH > 0 {IF printpause = 0 PrintTheQ().}
          //#region TRG FUNCTIONS
          function SetTrgVars{
            local parameter inlst,fldin is 0, evactin is 0.
            if DbgLog > 1 log2file("     SETTRGVARS:"+" fldin:"+fldin+" evactin:"+evactin+" FLD:"+fld).
            if evactin = 0 set evact to inlst[4].
              if inlst[0] <> "" and inlst[0] <> module2 set module1 to inlst[0]. 
              if inlst[1] <> "" and inlst[1] <> Event2On  set Event1On  to inlst[1].
              if inlst[2] <> "" and inlst[2] <> Event2Off set Event1Off to inlst[2]. 
              if inlst[3] <> "" set lightcheck to inlst[3].
            if fldin <> -1{
              if fldin = 0 set fld to " ". else set fld to fldin.
            }
            if DbgLog > 1 log2file("                MODULE:"+INLST[0]+" EVENT1ON:"+EVENT1ON+" EVENT1OFF:"+EVENT1OFF+" LIGHTCHECK:"+LIGHTCHECK).
          }
          FUNCTION LINKCHECK{
            local parameter inm, tnm.
            if DbgLog > 0 log2file("   LINKCHECK:"+ITEMLIST[Inm]+":"+PRTTAGLIST[INUM][TNM]+"("+LISTTOSTRING(AutoDspList[0][inm][tnm])+")").
            local itm2 to "0".
            SET AutoDspList[0][inm][tnm] TO DEDUP(AutoDspList[0][inm][tnm]).
            FOR I IN RANGE(AutoDspList[0][inm][tnm]:LENGTH-1,0){
              local itm1 to AutoDspList[0][inm][tnm][I].
              if itm2 <> itm1 {
                local aa to 0.
                global splt to itm1:split("-").
                if splt:length > 2 {if splt:length = 4{set aa to 0-splt[3]:tonumber. set splt[2] to aa:tostring.}
                local pnt to List(checktime,splt[0]:tonumber,splt[1]:tonumber,splt[2]:tonumber).
                if not ActionQNew:contains(pnt) ActionQNew:ADD(pnt).
                if aa = 0 AutoDspList[0][inm][tnm]:REMOVE(I).
                }
              }
              set itm2 to itm1.
            }
          }
          FUNCTION LGHTCHECK{
                LOCAL parameter  tn.
                local rtn is 0.
                if lighttag = 0 return rtn.
                FOR TG IN RANGE(1,prttaglist[1][0]+1){
              if prttaglist[1][TG] = tn {
                LOCAL SKP TO 0.
                IF prtList[1][TG][1]:HASMODULE("ModuleWheelDeployment") AND INUM <> GEARTAG SET SKP TO 1.
                IF prtList[1][TG][1]:HASMODULE("RetractableLadder") AND INUM <> ladtag SET SKP TO 1.
                IF SKP = 0{set rtn to 1. ActionQNew:ADD(List(TIME:SECONDS+1,1,TG,1)).}
                break.
              }
              }
              if DbgLog > 0 log2file("      LIGHTCHECK:"+TN+"("+rtn+")").
                return rtn.
          }
          function SetHudOptn{
            local parameter lchk, opchk, in, tn.
            if DbgLog > 1 log2file("      SETHUDOPTN-LCHK:"+LCHK+" opchk:"+opchk+" IN:"+IN+" TN:"+TN).
              if lchk = 1 {
                if opchk =1  SET GrpDspList[in][tn] TO 2.
                IF opchk =2 SET GrpDspList2[in][tn] TO 4.
                IF opchk =3 SET GrpDspList3[in][tn] TO 6.
              }
              if lchk = 2 {                  
                if opchk =1 SET  GrpDspList[in][tn] TO 1.
                IF opchk =2 SET GrpDspList2[in][tn] TO 3.
                IF opchk =3 SET GrpDspList3[in][tn] TO 5.
              }
              if forcerefresh = 0 set forcerefresh to 1.
              return.
          }
          function DcpPrtXtra{
            local parameter prt.
            if DbgLog > 0 log2file("   DCP PART EXTRA:"+prt).
              for chl in prt:children {
                for chl2 in chl:children {
                  for chl3 in chl2:children {
                    actions(chl3).}
                  actions(chl2).}
                actions(chl).
              }
                  local function actions{
                  local parameter prt2, m is "", evnt is "", evact is 1.
                  local cont to 0.
                    for it in DcpXtraMod{
                      if prt2:modules:contains(it){set cont to 1. break.}
                    }
                    if cont = 0 return.
                    
                  local ccc to GetActions("Actions",engModAlt,0, prt2,0,3,list("on", "activate")).
                    if  ccc[3] > 0 and prt2:tag = ""{set m to ccc[0]. set evnt to ccc[1]. set evact to ccc[4]. }
                  else{
                  local ccc to GetActions("Actions",engModAlt,0, prt2,0,3,list("off","shutdown")).
                    if  ccc[3] > 0 and prt2:tag = ""{set m to ccc[0]. set evnt to ccc[1]. set evact to ccc[4]. }
                  else{
                  local ccc to GetActions("Actions",chuteModAlt,0, prt2,0,3,list("deploy", "arm")).
                      if  ccc[3] > 0{set m to ccc[0]. set evnt to ccc[1]. set evact to ccc[4].}
                  else{
                  local ccc to GetActions("Actions",CntrlModAlt,0, prt2,0,3,list("toggle deploy")).
                      if  ccc[3] > 0{set m to ccc[0]. set evnt to ccc[1]. set evact to ccc[4].}
                  else{return.}}}}
                    if evact = 1 {if prt2:getmodule(m):hasevent(evnt) prt2:getmodule(m):doevent(evnt).}else
                    if evact = 2 {if prt2:getmodule(m):hasAction(evnt) prt2:getmodule(m):doAction(evnt, True).}
                }
              }
          function clearev{
            set event1on to "". set event1off to "". set module1 to "".
            set event2on to "". set event2off to "". set module2 to "".
          }
          //#endregion 
          RETURN.
      }
    //#region meter set
   function updatemeter{
        set sensordisp to list().
        IF FlState = "Space" OR FlState = "SpaceATM"{
          if hasnode = True{
            LOCAL TM TO formatTime(ETA:NEXTNODE).
            IF TM <> "PASSED" sensordisp:add("NODE:"+TM+"   ").
          }
          if orbit:hasnextpatch = True{
            LOCAL TM TO formatTime(ETA:TRANSITION).
            IF TM <> "PASSED" sensordisp:add("XSTN:"+TM+"   ").
          }
        }
        if senselist[3] = 1 and AutoValList[0][0][3][8]  <> 2 {sensordisp:add("PSR :"+round(SHIP:SENSORS:PRES,0)+" kPa").}
        if senselist[1] = 1 and AutoValList[0][0][3][11] <> 2 {sensordisp:add("GRAV:"+round(ship:sensors:grav:mag,1)+" M/S2").}
        if senselist[4] = 1 and AutoValList[0][0][3][10] <> 2 {sensordisp:add("TEMP:"+round(SHIP:SENSORS:TEMP,1)+" K").}
        if senselist[0] = 1 and AutoValList[0][0][3][12] <> 2 {sensordisp:add("ACCL:"+round(ship:sensors:acc:mag,1)+" G").}
        if senselist[2] = 1 and AutoValList[0][0][3][9]  <> 2 {sensordisp:add("SUN :"+round(SHIP:SENSORS:LIGHT,2)+" EXP").}
        sensordisp:add("                                        ").

        //add spd aand alt lock info here
        local lim to 7-ln14.
        IF sensordisp:LENGTH < lim {sensordisp:INSERT(0,"                                        "). SET LIM TO LIM+1.}
        for ln in range (0, lim){if ln < sensordisp:length print sensordisp[ln]+"     " at (1,ln+8).  else {if ln+9 < lim+8 print "                                        " at (1,ln+8). break.}
        //IF dbglog > 0 log2file("    LIM:"+(LIM)+" LN:"+(LN)+" LIM:"+(LIM+8)+" LN:"+(LN+9)+" LENGTH:"+sensordisp:LENGTH+" ln14:"+ln14).
        }
        if dcptag <> 0 and hsel[2][1] = dcptag and fuelmon = 1 {
          IF DCPRes = 0 {
            local rscl to getRSCList(DcpPrtList[hsel[2][2]][1]:resources).
            set prsclist to rscl[0].
            set prsclist2 to rscl[2].
            set pRscNum to rscl[1].
            SET DCPRes TO 1.
          }

            local lm to widthlim-5-ClrMin. 
            local fmtr to GetFuelLeft(DcpPrtList[hsel[2][2]],3,0,RscSelection).
            local lcl to MtrColor(fmtr).
            printline (" "+HudOpts[1][1],0,16).
            if lcl:istype("string") and HudOpts[1][1] <> "No Part"{
              PRINTLINE("("+fmtr+"%)"+GetFuelLeft(DcpPrtList[hsel[2][2]],0,lm,RscSelection),lcl).
              }
             ///print getcolor("("+fmtr+"%):"+GetFuelLeft(DcpPrtList[hsel[2][2]],1,lm),lcl):padleft(79) at (1,17).
        }
    }
   function MtrColor{
  local parameter pctin.
  local lcl to "GRN".
  if pctin < 10 set lcl to "RED". else{
  if pctin < 25 set lcl to "RRN". else{
  if pctin < 40 set lcl to "ORN". else{
  if pctin < 55 set lcl to "YRN". else{
  if pctin < 70 set lcl to "YLW". else{
  if pctin < 85 set lcl to "YGR".}}}}}
  return lcl.
}
   FUNCTION SETHUD{
          if rowval = 0 {
            SET HUDOP TO 1.
            if hsel[2][1] = scitag{} SET HUDOP TO 2.
          }
          if rowval = 1 {
              SET HUDOP TO 4.
              if hsel[2][1] = DCPtag{SET HUDOP TO 10. set hudoptsl[1][10] to "RSRC   ". set hudoptsl[3][10] to "RSRC   ".SET HDXT TO "    ".}
              else{
              if hsel[2][1] = engtag{SET HUDOP TO 3. }
              else{
              if hsel[2][1] = scitag OR hsel[2][1] = ISRUtag{ SET HUDOP TO 6.}
              else{
              if hsel[2][1] = anttag and rtech <> 0{SET HUDOP TO 7.       }
              else{
              if hsel[2][1] = cntrltag or hsel[2][1] = RCStag{ SET HUDOP TO 8. }
              else{
              if hsel[2][1] = WMGRtag{set HUDOP TO 9.}
              else{
              if hsel[2][1] = CHUTETAG or hsel[2][1] = RBTTag or  hsel[2][1] = BDPTag or (hsel[2][1] = GearTag AND CurrentPart:hasmodule("ModuleWheelDeployment") ){set hudop to 10. set hudoptsl[1][10] to "LIMIT  ". set hudoptsl[3][10] to "LIMIT  ".SET HDXT TO "OPTN".}
              else{
              if hsel[2][1] = Flytag{set hudop to 10.
                if ItmTrg = " SET TRGT "{set hudoptsl[1][10] to "TARGET ". set hudoptsl[3][10] to "TARGET ".SET HDXT TO "    ".}
                else{set hudoptsl[1][10] to "LIMIT  ". set hudoptsl[3][10] to "LIMIT  ".SET HDXT TO "AMNT".}}
              else{
              if mks = 1 {
                if hsel[2][1] = pwrtag or hsel[2][1] = MksDrlTag {set hudop to 10. set hudoptsl[1][10] to "GOV    ". set hudoptsl[3][10] to "GOV    ".}
              }else{}}}}}}}}}
          }
          print "         " AT (61,8).
          if hudop <> 5 and hudopprev = 5 {PRINTLINE(). PRINTLINE("",0,16). }
    }
   function GetFuelLeft{
     local parameter prts, opt is 1, GMAX IS 0, resnum is 0.
     local prtf to prts:copy.
     if resnum:istype("string"){
      if hudop <> 5 and hsel[2][2] = dcptag {
        set resnum to pRscNum[resnum].
        }
      else{ set resnum to RscNum[resnum].}
     }
      local PctTot to 0.
      set cnt to 0.
      if prtf:length = 0 return.
         prtf:add("").
      local pl to prtf:sublist(1, prtf:length).
      if pl:length = 0 return.
      if dbglog > 2 log2file("    GETFUELLEFT:"+LISTTOSTRING(pl)+" OPT:"+opt+" gmax:"+gmax+" resnum:"+resnum + " AUTOTRG:"+autoTRGList[0][hsel[1][1]][hsel[1][2]]).
      local gauge to ":".
      local DCPGone to 1.
      if autoTRGList[0][hsel[1][1]][hsel[1][2]] > -1 {
          for p IN pl{
              if p <> "" {
                if dbglog > 2 log2file("    PRT:"+p).
                IF P <> CORE:PART{
                  set DCPGone to 0.
                  IF  p:resources[resnum]:capacity > 0 {
                    if p:resources:length > max(resnum-1,0) {
                      if Ship:parts:contains(p){
                        set resource to p:resources[resnum].
                        set ResCur to resource:name+":".
                        set percentage to resource:amount / resource:capacity * 100.
                        set cnt to cnt+1.
                        set PctTot to PctTot+percentage.
                      }
                    }
                    else{if opt < 3{set HudOpts[1][1] to "". set HudOpts[1][2] to "".} set gauge to ":No resources".}
                  }else{set HudOpts[1][1] to p:resources[resnum]:name+":". if opt < 3 set gauge to ":No res. storage". else set gauge to 0.}
                }
              }
          }
          }
              if DCPGone = 1 {set HudOpts[1][1] to "No Part". set HudOpts[1][2] to " ". set gauge to "                                                                       ".}
              else{
                if gauge = ":No resources" or cnt = 0 or gauge = 0{}else{
                  set percentage to PctTot/cnt.
                  if opt =3 {set gauge to round(percentage).}
                  if opt =4 {set gauge to round(percentage,3).}
                  IF OPT < 3{
                    if opt =1 set ResCur to rescur + " ".
                    set HudOpts[1][1] to rescur.
                    set gauge to SetGauge(percentage, 1, GMAX).
                    if gauge = ":" set gauge to ":EMPTY                       ".
                  }
                }
              }
              if dbglog > 2 log2file("      "+resource+" AMT:"+gauge+" DCPGONE:"+DCPGone). 
              return gauge.
    }
   function adjust_thrust {
     LOCAL parameter PrtsIN, amount, direction, op is 1.
      LOCAL PrtsIN2 to PrtsIN:sublist(1, PrtsIN:length).
     if op =1{
        for engine in PrtsIN2 {
          set CurLim to engine:thrustlimit.
          if direction = "+" {set NewLim to CurLim + amount.
          } else {set NewLim to CurLim - amount.}
          set NewLim to max(0, min(100, NewLim)).
          set engine:thrustlimit to NewLim.
        }
      }
     if op =2{
        for GOV in PrtsIN2 {
          set CurLim to GOV:getmodule("mksmodule"):getfield("governor").
          if direction = "+" {set NewLim to CurLim + amount.
          } else {set NewLim to CurLim - amount.}
          if newlim > 1 set NewLim to 1. if newlim < 0 set NewLim to 0.
          GOV:getmodule("mksmodule"):setfield("governor", NewLim).
        }
      }
    }
   function adjust_Meter {
      LOCAL parameter PrtsIN, amount, direction, op is 1, inum is 1, limitlow is 0, limit is 100.
      IF dbglog > 2 {
        log2file("    ADJUST METER:"+" amount:"+amount+" direction:"+direction+" op:"+op+" inum:"+inum+" limitlow:"+limitlow+" limit:"+limit).
        log2file("        "+LISTTOSTRING(PrtsIN)).
        }
      ///print PrtsIN+"-"+ amount+"-"+ direction+"-"+ op+"-"+ inum+"-"+ limitlow+"-"+ limit.
      LOCAL PrtsIN2 to PrtsIN:sublist(1, PrtsIN:length).
      local opset to op.
      local optn1 to opset*3-2.
        for Pt in PrtsIN2 {
          if pt:hasmodule(modulelist[inum][optn1]){
            if Pt:getmodule(modulelist[inum][optn1]):hasfield(modulelistRPT[inum][optn1]){
              set CurLim to Pt:getmodule(modulelist[inum][optn1]):getfield(modulelistRPT[inum][optn1]).
              if CurLim:typename <> "Scalar" set CurLim to CurLim:tonumber.
              if direction = "+" {set NewLim to CurLim + amount.} else {set NewLim to CurLim - amount.}
              if newlim > limit set NewLim to limit. 
              if newlim < limitlow set NewLim to limitlow.
              Pt:getmodule(modulelist[inum][optn1]):setfield(modulelistRPT[inum][optn1], NewLim).
              IF dbglog > 2 {
                log2file("        PART:"+pT+" FIELD:"+modulelistRPT[inum][optn1]+" SET TO:"+NewLim).
              }
            }
          }
        }
    }
   function CheckDcpFuel{
    if dbglog > 2 log2file(" CHECKDCPFUEL").
  for t in Range(1,prttagList[dcptag][0]+1){
    if AutoDspList[dcptag][T] = modeshrt:find("FUEL") {
      if not prttaglist[dcptag][T]:contains("Payload"){
      local trg to 0. 
      local vl to abs(AutoValList[dcptag][T]).
      if vl = 1 set vl to 0.01.
      local fllft to GetFuelLeft(DcpPrtList[T],4,0,AutoRscList[dcptag][T]).
        if not fllft:tostring:contains("                                                                       ") {
          if AutoValList[dcptag][T] > -0.0001 AND fllft > vl set trg to 1.
          if AutoValList[dcptag][T] <  0.0001 AND fllft < vl set trg to 2.
          if dbglog > 2 log2file("     T("+T+")trg("+trg+") - TargetVal:"+vl+" - ActVal:"+fllft).
          if trg > 0{ToggleGroup(dcptag,t,1,1). ClearAuto(dcptag,t,trg,modeshrt:find("FUEL")).}
        } 
      }
    }
  }
}
   function SetGauge{ //returns gauge of 0-100 percent set to fit after row items 1 and 2. 
      local parameter pct, row, Gmax is 0.
      //if dbglog > 2 log2file("    SETGUAGE: pct:"+pct).
      local gauge to ":".
      if pct <> "                                    "{
      if pct:typename <> "Scalar"{
        set pct to removeletters(pct).
        set pct to pct:tonumber.
      }
      if pct < 100.001 {if pct > 100 set pct to 100.
       if Gmax = 0{set GaugeLim to widthlim-3-HudOpts[row][1]:length-HudOpts[row][2]:tostring:length.}else {set GaugeLim to Gmax.}
        FOR i IN RANGE(1, round(pct/(100/GaugeLim),0)) {set gauge to gauge+"=".}
        FOR i IN RANGE(round(pct/(100/GaugeLim),0),100/(100/GaugeLim)) {set gauge to gauge+"_".}
      }else{set gauge to ":OVER LIMIT!!!".}
      return gauge.} else{return pct.}
    }   
//#region MKS
   Function MKSConvCheck{
    local parameter fl,J,huditem, hudtag.
    local err1 to "". local err2 to "".
      if fl = "reactor"{ 
          if ship:resources[RscNum["EnrichedUranium"]]:capacity = 0 set err1 to ": No Enriched Uranium Storage". else if ship:resources[RscNum["EnrichedUranium"]]:amount < 0.01 set err1 to ": No Enriched Uranium".
          if ship:resources[RscNum["DepletedFuel"]]:capacity = 0 set err2 to ": No Depleted Fuel Storage". else if ship:resources[RscNum["DepletedFuel"]]:amount > ship:resources[RscNum["DepletedFuel"]]:capacity-0.5 set err2 to ": Depleted Fuel Full". 
          if err1+err2 = "" {
              set hudopts[J][2] to hudopts[J][3]+":Enriched Uranium".
              set hudopts[J][3] to SetGauge(ship:resources[RscNum["EnrichedUranium"]]:amount/ship:resources[RscNum["EnrichedUranium"]]:capacity*100,J).
          }else{
              set hudopts[J][3] to err1+err2. 
              set GrpDspList[HudItem][hudtag] to 1. set forcerefresh to 1.
          }
      }else{   
        if fl = "agroponics" or fl = "[greenhouse]" { ResourceCheck(j, huditem, hudtag, "Mulch", "", "Fertilizer", "", ""). }else{                                                       //working
        if fl = "chemicals"                  { ResourceCheck(j, huditem, hudtag,"Minerals"        , ""                , ""           , ""                  , "Chemicals"        ). }else{//working
        if fl = "[smelter]"                  { ResourceCheck(j, huditem, hudtag,"Machinery"       , ""                , ""           , ""                  , ""                 ). }else{//working
        if fl = "[crushser]"                 { ResourceCheck(j, huditem, hudtag,"Machinery"       , ""                , ""           , ""                  , ""                 ). }else{//working
        if fl = "Sifter"                     { ResourceCheck(j, huditem, hudtag,"Dirt"            , ""                , ""           , ""                  , "Machinery"        ). }else{//working
        if fl = "Silicon"                    { ResourceCheck(j, huditem, hudtag,"Silicates"       , "Machinery"       , ""           , ""                  , "Silicon"          ). }else{//working
        if fl = "Polymers"                   { ResourceCheck(j, huditem, hudtag,"Substrate"       , ""                , ""           , ""                  , "Polymers"         ). }else{//working
        if fl = "RefinedExotics"             { ResourceCheck(j, huditem, hudtag,"ExoticMinerals"  , "RareMetals"      , "Chemicals"  , ""                  , "RefinedExotics"   ). }else{
        if fl = "h2o (Hyd)"                  { ResourceCheck(j, huditem, hudtag,"Hydrates"        , ""                , ""           , ""                  , "Water"            ). }else{//working
        if fl = "h2o (Kar)"                  { ResourceCheck(j, huditem, hudtag,"Karbonite"       , ""                , ""           , ""                  , "Water"            ). }else{
        if fl = "h2o (Ore)"                  { ResourceCheck(j, huditem, hudtag,"Ore"             , ""                , ""           , ""                  , "Water"            ). }else{//working
        if fl = "Chemicals"                  { ResourceCheck(j, huditem, hudtag,"Minerals"        , ""                , ""           , ""                  , "Chemicals"        ). }else{//working
        if fl = "Fertilizer(G)"              { ResourceCheck(j, huditem, hudtag,"Gypsum"          , ""                , ""           , ""                  , "Fertilizer"       ). }else{//working
        if fl = "Fertilizer(M)"              { ResourceCheck(j, huditem, hudtag,"Minerals"        , ""                , ""           , ""                  , "Fertilizer"       ). }else{//working
        if fl = "Metals"                     { ResourceCheck(j, huditem, hudtag,"MetallicOre"     , ""                , ""           , ""                  , "Metals"           ). }else{//working
        if fl = "LFO"                        { ResourceCheck(j, huditem, hudtag,"Ore"             , ""                , ""           , ""                  , "LiquidFuel"       , "Oxidizer"). }else{//not sure always full
        if fl = "LiquidFuel"                 { ResourceCheck(j, huditem, hudtag,"Ore"             , ""                , ""           , ""                  , "LiquidFuel"       ). }else{//not sure always full
        if fl = "Monopropellant"             { ResourceCheck(j, huditem, hudtag,"Ore"             , ""                , ""           , ""                  , "Monopropellant"   ). }else{
        if fl = "Recycling"                  { ResourceCheck(j, huditem, hudtag,"Recyclables"     , ""                , ""           , ""                  , "Metals"           ,"Chemicals", "Polymers"). }else{//working
        if fl = "RocketParts"                { ResourceCheck(j, huditem, hudtag,"SpecializedParts", "MaterialKits"    , ""           , ""                  , "RocketParts"      ). }else{
        if fl = "DepletedFuel"               { ResourceCheck(j, huditem, hudtag,"DepletedFuel"    , ""                , ""           , ""                  , "EnrichedUranium"  ). }else{
        if fl = "SpecializedParts"           { ResourceCheck(j, huditem, hudtag,"RefinedExotics"  , ""                , "Silicon"    , ""                  , "SpecializedParts" ). }else{//working
        if fl = "MaterialKits"               { ResourceCheck(j, huditem, hudtag,"Metals"          , "Polymers"        , "Chemicals"  , ""                  , "MaterialKits"     ). }else{//working
        if fl = "agriculture(s)"             { ResourceCheck(j, huditem, hudtag,"Substrate"       , "Water"           , "Fertilizer" , "Organics"          , ""                 ). }else{//good
        if fl = "agriculture(d)"             { ResourceCheck(j, huditem, hudtag,"Dirt"            , "Water"           , "Organics"   , "Fertilizer"        , ""                 ). }else{//working
        if fl = "ColonySupplies"             { ResourceCheck(j, huditem, hudtag,"Organics"        , "SpecializedParts", "MaterialKits", ""                 , "ColonySupplies"   ). }else{
        if fl = "Machinery"                  { ResourceCheck(j, huditem, hudtag,"SpecializedParts", ""                , "MaterialKits", ""                 , "Machinery"        ). }else{//working
        if fl = "EnrichedUranium"            { ResourceCheck(j, huditem, hudtag,"Uraninite"       , ""                , ""           , ""                  , "EnrichedUranium"  ). }else{
        if fl = "Deuterium"                  { ResourceCheck(j, huditem, hudtag,"Deuterium"       , "Helium3"         , ""           , ""                  , "D2"               ). }else{
        if fl = "FusionPellets"              { ResourceCheck(j, huditem, hudtag,"FusionPellets"   , ""                , "Helium3"    , ""                  , ""                 ). }else{
        if fl = "Silicates"                  { ResourceCheck(j, huditem, hudtag,"Silicates"       , ""                , ""           , ""                  , "Silicates"        ). }else{
        if fl = "Minerals"                   { ResourceCheck(j, huditem, hudtag,""                , ""                , ""           , ""                  , "Minerals"         ). }else{
        if fl = "MetallicOre"                { ResourceCheck(j, huditem, hudtag,""                , ""                , ""           , ""                  , "MetallicOre"      ). }else{
        if fl = "cultivate(s)"               { ResourceCheck(j, huditem, hudtag,"Substrate"       , "Water"           , "Fertilizer" , ""                  , ""                 ). }else{//working
        if fl = "cultivate(d)"               { ResourceCheck(j, huditem, hudtag,"Dirt"            , "Water"           , "Fertilizer" , ""                  , ""                 ). }else{//working
        if fl = "centrifuge"                 { ResourceCheck(j, huditem, hudtag,"Uraninite"       , ""                , ""           , ""                  , "EnrichedUranium"  ). }else{//working
        if fl = "breeder"                    { ResourceCheck(j, huditem, hudtag,"depletedfuel"    , ""                , ""           , ""                  , "EnrichedUranium"  ). }else{//working
        if fl = "electronics"                { ResourceCheck(j, huditem, hudtag,"MaterialKits"    , "Synthetics"      , ""           , ""                  , "electronics"      ). }else{//working
        if fl = "Alloys"                     { ResourceCheck(j, huditem, hudtag,"Metals"          , "RareMetals"      , ""           , ""                  , "Alloys"           ). }else{//working
        if fl = "Prototypes"                 { ResourceCheck(j, huditem, hudtag,"Electronics"     , "Robotics"        , "Machinery"  , "SpecializedParts"  , ""                 ). }else{//working
        if fl = "Robotics"                   { ResourceCheck(j, huditem, hudtag,"Alloys"          , "MaterialKits"    , "Machinery"  , ""                  , "Robotics"         ). }else{//working      
        if fl = "Synthetics"                 { ResourceCheck(j, huditem, hudtag,"Machinery"       , "ExoticMinerals"  , "Polymers"   , ""                  , "Synthetics"       ). }else{//working     
        if fl = "Dirt"                       { ResourceCheck(j, huditem, hudtag,""                , ""                , ""           , ""                  , "Dirt"       ). }else{//working  
        if fl = "transportCredits"           { ResourceCheck(j, huditem, hudtag,"MaterialKits"    , "liquidfuel"      , ""           , ""                  , "transportCredits"). }else{//working  
        //if fl = "Lodeharvester"            { ResourceCheck(j, huditem, hudtag,""                , ""                , ""           , ""                  , "ResourceNode"  ). }else{//working



          
        }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
  }
   Function MKSDrillCheck{
      local parameter fl,j,huditem, hudtag.
        if fl = "Dirt"                      { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Dirt"             ). }else{//working      
        if fl = "Minerals"                  { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Minerals"         ). }else{
        if fl = "Silicates"                 { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Silicates"        ). }else{
        if fl = "Ore"                       { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Ore"              ). }else{
        if fl = "Exotic Minerals"           { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "ExoticMinerals"   ). }else{
        if fl = "Karbonite"                 { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Karbonite"        ). }else{
        if fl = "Uraninite"                 { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Uraninite"        ). }else{
        if fl = "Gypsum"                    { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Gypsum"           ). }else{
        if fl = "Substrate"                 { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Substrate"        ). }else{
        if fl = "MetallicOre"               { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "MetallicOre"      ). }else{
        if fl = "Water"                     { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Water"            ). }else{
        if fl = "Hydrates"                  { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Hydrates"         ). }else{
        if fl = "Uraninite"                 { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Uraninite"        ). }else{
        if fl = "RareMetals"                { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "RareMetals"       ). }else{
        if fl = "Rock"                      { ResourceCheck(j, huditem, hudtag, ""       , ""                , ""           , ""                  , "Rock"             ). }else{
        }}}}}}}}}}}}}}}
   
  }
   function ResourceCheck {
      local parameter j, huditem, hudtag, RsIn1, RsIn2, RsIn3, RsIn4 is "", RsOt1 is "", RsOt2 is "", RsOt3 is "".
      local err1 to "". local err2 to "". local err3 to "". local err4 to "". local GgL to 0. local ggl2 to 0.
      local p1 to 0. local p2 to 0. local p3 to 0. local p4 to 0. LOCAL P5 TO 0. local p6 to 0. local p7 to 0.
      if RsIn1 <> ""{set p1 to 1. 
        if RscNum:HASKEY(RsIn1){
          set ggl to ggl+ RscList[RscNum[RsIn1]][1]:length+1.
          if ship:resources[RscNum[RsIn1]]:capacity = 0 set err1 to ": No " +RscList[RscNum[RsIn1]][1] + " Storage". 
          else if ship:resources[RscNum[RsIn1]]:amount < 0.01 set err1 to ": No " +RscList[RscNum[RsIn1]][1].
        }else{Set err1 to ": No " +RsIn1+ " Storage".} 
      }
      if RsIn2 <> ""{set p2 to 1. 
        if RscNum:HASKEY(RsIn2){
          set ggl to ggl+RscList[RscNum[RsIn2]][1]:length+2.
          if ship:resources[RscNum[RsIn2]]:capacity = 0 set err2 to ": No " +RscList[RscNum[RsIn2]][1] + " Storage". 
          else if ship:resources[RscNum[RsIn2]]:amount < 0.01 set err2 to ": No " +RscList[RscNum[RsIn2]][1].
        }else{Set err2 to ": No " +RsIn2+ " Storage". }
      }
      if RsIn3 <> ""{set p3 to 1. set p6 to 1.
        if RscNum:HASKEY(RsIn3){
          set ggl2 to ggl2+RscList[RscNum[RsIn3]][1]:length.
          if ship:resources[RscNum[RsIn3]]:capacity = 0 set err3 to ": No " +RscList[RscNum[RsIn3]][1] + " Storage". 
          else if ship:resources[RscNum[RsIn3]]:amount < 0.01 set err3 to ": No " +RscList[RscNum[RsIn3]][1].
        }else{set err3 to ": No " +RsIn3+ " Storage". }
      }
      if RsIn4 <> ""{set p4 to 1. 
        if RscNum:HASKEY(RsIn4){
          set ggl2 to ggl2+RscList[RscNum[RsIn4]][1]:length+1.
          if ship:resources[RscNum[RsIn4]]:capacity = 0 set err4 to ": No " +RscList[RscNum[RsIn4]][1] + " Storage". 
          else if ship:resources[RscNum[RsIn4]]:amount < 0.01 set err4 to ": No " +RscList[RscNum[RsIn4]][1].
        }else{set err4 to ": No " +RsIn4+ " Storage". }
      }
      if RsOt1 <> ""{set p4 to 1. SET P5 TO 1. 
        if RscNum:HASKEY(RsOt1){
          set ggl2 to ggl2+RscList[RscNum[RsOt1]][1]:length+1.
          if ship:resources[RscNum[RsOt1]]:capacity = 0 set err4 to ": No " +RscList[RscNum[RsOt1]][1] + " Storage". 
          else if ship:resources[RscNum[RsOt1]]:amount > ship:resources[RscNum[RsOt1]]:capacity-0.5 set err4 to ": "+RscList[RscNum[RsOt1]][1]+" Full".
        }else{set err4 to ": No " +RsOt1+ " Storage". }
      }
      if RsOt2 <> ""{set p6 to 1. SET P4 TO 1. set p5 to 2. 
        if RscNum:HASKEY(RsOt2) {
        if  RscNum:HASKEY(RsOt1){
        set ggl2 to ggl2+RscList[RscNum[RsOt2]][1]:length+1.
        if ship:resources[RscNum[RsOt1]]:capacity = 0 set err3 to ": No " +RscList[RscNum[RsOt1]][1] + " Storage". 
          else if ship:resources[RscNum[RsOt1]]:amount > ship:resources[RscNum[RsOt1]]:capacity-0.5 set err3 to ": "+RscList[RscNum[RsOt1]][1]+" Full".
        set err4 to"".
        if ship:resources[RscNum[RsOt2]]:capacity = 0 set err4 to ": No " +RscList[RscNum[RsOt2]][1] + " Storage". 
          else if ship:resources[RscNum[RsOt2]]:amount > ship:resources[RscNum[RsOt2]]:capacity-0.5 set err4 to ": "+RscList[RscNum[RsOt2]][1]+" Full".
      }else{}
        }else{set err3 to ": No " +RsOt2+ " Storage". }
      }
      if RsOt3 <> ""{set p7 to 1. 
        if RscNum:HASKEY(RsOt3){
        set ggl to ggl+RscList[RscNum[RsOt3]][1]:length+2.
          if ship:resources[RscNum[RsOt3]]:capacity = 0 set err2 to ": No " +RscList[RscNum[RsOt3]][1] + " Storage". 
            else if ship:resources[RscNum[RsOt3]]:amount > ship:resources[RscNum[RsOt3]]:capacity-0.5 set err2 to ": "+RscList[RscNum[RsOt3]][1]+" Full".
        }else{set err4 to ": No " +RsOt3+ " Storage".}       
      }
            if err1+err2+err3+err4 = "" {
              set ggl  to (widthlim-3-ggl-hudopts[J][3]:length-hudopts[J][2]:length-hudopts[J][1]:length)/2*(2-p2-p7)-1.
              set ggl2 to (widthlim-3-ggl2)/2*(2-p6).
                if p1 = 1             set err1 to RscList[RscNum[RsIn1]][1]+SetGauge(ship:resources[RscNum[RsIn1]]:amount/ship:resources[RscNum[RsIn1]]:capacity*100,J,GgL).
                if p2 = 1             set err2 to RscList[RscNum[RsIn2]][1]+SetGauge(ship:resources[RscNum[RsIn2]]:amount/ship:resources[RscNum[RsIn2]]:capacity*100,J,GgL).
                if p7 = 1             set err2 to RscList[RscNum[RsOt3]][1]+SetGauge(ship:resources[RscNum[RsOt3]]:amount/ship:resources[RscNum[RsOt3]]:capacity*100,J,GgL).
                if p3 = 1             set err3 to RscList[RscNum[RsIn3]][1]+SetGauge(ship:resources[RscNum[RsIn3]]:amount/ship:resources[RscNum[RsIn3]]:capacity*100,J,(GgL2)).
                if p4 = 1 AND P5 = 0  set err4 to RscList[RscNum[RsIn4]][1]+SetGauge(ship:resources[RscNum[RsIn4]]:amount/ship:resources[RscNum[RsIn4]]:capacity*100,J,(GgL2)).
                if p4 = 1 AND P5 = 1  {
                  if p1+p2>0{set err4 to RscList[RscNum[RsOt1]][1]+SetGauge(ship:resources[RscNum[RsOt1]]:amount/ship:resources[RscNum[RsOt1]]:capacity*100,J,(GgL2)).}
                  else{      set err2 to RscList[RscNum[RsOt1]][1]+SetGauge(ship:resources[RscNum[RsOt1]]:amount/ship:resources[RscNum[RsOt1]]:capacity*100,J,(GgL-5)).}
                }
                if p4 = 1 AND P5 = 2  set err3 to RscList[RscNum[RsOt1]][1]+SetGauge(ship:resources[RscNum[RsOt1]]:amount/ship:resources[RscNum[RsOt1]]:capacity*100,J,(GgL2)).
                if p5 = 2             set err4 to RscList[RscNum[RsOt2]][1]+SetGauge(ship:resources[RscNum[RsOt2]]:amount/ship:resources[RscNum[RsOt2]]:capacity*100,J,(GgL2)).
                set hudopts[J][3] to hudopts[J][3]+err1+" "+err2.
                set botrow to err3+" "+err4.
            }else{
              if huditem = pwrtag{
                set hudopts[J][3] to ":not converting:".
                set botrow to err1+err2+err3+err4.
                set GrpDspList[HudItem][hudtag] to 1.
                set forcerefresh to 1.
              }
              if huditem = MksDrlTag{
                set hudopts[J][3] to ":not Active:"+err1+err2+err3+err4.
                set GrpDspList2[HudItem][hudtag] to 4.
                set forcerefresh to 1.
              }

            }
    }
    //#endregion
    //#endregion
    //#region get text info
   FUNCTION CHANGESEL{
    local parameter OMAX, CURRENT, DIR, OMIN is 1.
        IF dbglog > 2 log2file("    CHANGESEL:"+" CURRENT:"+ CURRENT+" DIR:"+ DIR+" OMIN:"+ OMIN+" OMAX:"+ OMAX).
        IF DIR = "+" {IF CURRENT < OMAX {SET CURRENT TO CURRENT + 1.}ELSE{SET CURRENT TO OMIN.}}else{
        IF DIR = "-" {IF CURRENT > OMIN {SET CURRENT TO CURRENT - 1.}ELSE{SET CURRENT TO OMAX.}}}
        IF dbglog > 2 log2file("         OUT:"+CURRENT).
        RETURN CURRENT.
        
    }
   function ToggleResConv{
    local parameter prt, rsrc, rscnumL, mode is 1.
    local ans to "".
    if rsrc = "liquidfuel" set rsrc to "lqdfuel".
    if rsrc = "oxidizer" set rsrc to "ox".
      local t to prt:getmodulebyindex(rscnumL).
      if prt:hasmodule("ModuleResourceConverter"){
        if t:HASEVENT("start isru ["+rsrc+"]"){set ans to "not converting      ".
          if mode = 1 {t:DOEVENT("start isru ["+rsrc+"]"). set ans to "converting            ".}}
        else{
        if t:HASEVENT("stop isru ["+rsrc+"]"){set ans to "converting            ".
          if mode = 1 {t:DOEVENT("stop isru ["+rsrc+"]"). set ans to "not converting      ".}}
        }}
      return ans.
    }
   FUNCTION ADDMAX{
    LOCAL PARAMETER NmIn, NmAdd, NmMin, NmMax, opt is 1.
    if dbglog > 2 log2file("    ADDMAX:"+" NmIn:"+NmIn+" NmAdd:"+NmAdd+" NmMin:"+NmMin+" NmMax:"+NmMax+" opt:"+opt).
    set nmcalc to NmIn+NmAdd.
    if opt = 1{
      IF nmcalc > NmMax SET nmcalc TO(nmcalc- NmMax)-NmMin-1.
      IF nmcalc < NmMin SET nmcalc TO NmMax-abs(nmcalc+ NmMin)+1.
      RETURN nmcalc.
    }
    if opt = 2{
      IF nmcalc > NmMax SET nmcalc to NmMin.
      IF nmcalc < NmMin SET nmcalc TO NmMax.
      RETURN nmcalc.
    }
    if opt = 3{
      IF nmcalc > NmMax SET nmcalc to NmMax.
      IF nmcalc < NmMin SET nmcalc TO NmMin.
      RETURN nmcalc.
    }
   }
   function wordcheck{
      local parameter input, wordchk.
      local ans to 0.
      for w in wordchk{if input:contains(w){set ans to 1. BREAK.}}
      return ans.
    }
   FUNCTION CHECKOPT{
      local parameter OMAX, CURRENT, DIR, LstIn IS LIST(""), omin is 1, opt is 0.

      IF DIR = "+" {IF CURRENT < OMAX {SET CURRENT TO CURRENT + 1.}ELSE{SET CURRENT TO omin.}}
      IF DIR = "-" {IF CURRENT > omin {SET CURRENT TO CURRENT - 1.}ELSE{SET CURRENT TO OMAX.}}
      if LstIn = 6 {
        until AutoRscList[0][current] = 1 {
          IF DIR = "+" {IF CURRENT < OMAX {SET CURRENT TO CURRENT + 1.}ELSE{SET CURRENT TO omin.}}
          IF DIR = "-" {IF CURRENT > omin {SET CURRENT TO CURRENT - 1.}ELSE{SET CURRENT TO OMAX.}}
        }
        RETURN ItemListHUD[CURRENT].
      }
      if LstIn = 7 {local selprv to CURRENT.
        until autoTRGList[0][HSEL[2][1]][CURRENT] > -1 {
          IF DIR = "+" {IF CURRENT < OMAX {SET CURRENT TO CURRENT + 1.}ELSE{SET CURRENT TO omin.}}
          IF DIR = "-" {IF CURRENT > omin {SET CURRENT TO CURRENT - 1.}ELSE{SET CURRENT TO OMAX.}}
          if current = selprv break.
        }
        RETURN  PRTTAGLIST[hsel[2][1]][CURRENT].
      }
      if LSTIN:typename = "string" return.
      IF LSTIN[0]= "" RETURN.
      if opt = 0 return LstIn[CURRENT]. else return LstIn[CURRENT]:substring(0,(min(LstIn[CURRENT]:length, 11))).

    }
   //#endregion
    //#region auto
   function clearauto{
    local parameter item, tag, updn, opt, RSM IS autoRstList[item][tag].
    LOCAL UPDN2 TO 0.
    if DbgLog > 0 {
      log2file("      CLEAR AUTO-:"+itemlist[item]+":"+prttaglist[item][tag]).
      if DbgLog > 1 {
        log2file("        "+item+" tag:"+tag+" updn:"+updn+" opt:"+opt ).
        log2file("        autoRstList[item][tag](RSMD):"+RSM ).
        log2file("        AutoValList[item][tag]("+AutoValList[item][tag]+"):"). 
        local lud to "OVER".
        if updn = 2 set lud to "UNDER".
        if updn = 2 set lud to "OVER-OFF".
        if updn = 2 set lud to "UNDER-OFF".
        log2file("        AutoLst["+MODELONG[opt]+"("+opt+")]["+lud+"("+updn+")]["+itemlist[item]+"("+item+")]    :"+LISTTOSTRING(AutoLst[opt][updn][item]) ).
        if AutotagLstUP[item]:length > 1 log2file("         AutotagLstUP["+item+"]:"+LISTTOSTRING(AutotagLstUP[item]) ).
        if AutotagLstDN[item]:length > 1 log2file("         AutotagLstDN["+item+"]:"+LISTTOSTRING(AutotagLstDN[item]) ).
        if  AutotagLstNAup[item]:length > 1 log2file("        AutotagLstNAup["+item+"]:"+LISTTOSTRING(AutotagLstNAup[item]) ).
        if  AutotagLstNADN[item]:length > 1 log2file("        AutotagLstNADN["+item+"]:"+LISTTOSTRING(AutotagLstNADN[item]) ).
      }
    }
    set cnt to 0.
    local trm to 0.
    local lst1 to AutoLst[opt][updn][item]:sublist(0, AutoLst[opt][updn][item]:length).
    for i in lst1{
      if RSM = 1 {
        local trg1 to 0.
        if updn = 1 and i = AutoValList[item][tag] set trg1 to 1.
        if updn = 2 and 0-i = AutoValList[item][tag] set trg1 to 2. 
          if trg1 > 0{
            set trm to 1.
            set AutoLst[opt][updn][item][cnt] to 0.
            if   AutotagLstDN[item]:contains(tag)   AutotagLstDN[item]:remove(AutotagLstDN[item]:find(tag)).
            if   AutotagLstUP[item]:contains(tag)   AutotagLstUP[item]:remove(AutotagLstUP[item]:find(tag)).
            if AutotagLstNADN[item]:contains(tag) AutotagLstNADN[item]:remove(AutotagLstNADN[item]:find(tag)).
            if AutotagLstNAup[item]:contains(tag) AutotagLstNAup[item]:remove(AutotagLstNAup[item]:find(tag)).
            break.
          }
          set cnt to cnt+1.
      }
      else{
        if RSM > 1 {
            if updn = 1 and i = AutoValList[item][tag]{
              if DbgLog > 0 log2file("      "+itemlist[item]+":"+prttaglist[item][tag]+" switched to UNDER" ).
              SET UPDN2 TO 2.
              set AutoValList[item][tag] to 0-ABS(AutoValList[item][tag]).
            }
            if updn = 2 and 0-i = AutoValList[item][tag]{
              if DbgLog > 0 log2file("      "+itemlist[item]+":"+prttaglist[item][tag]+" switched to OVER" ).
              SET UPDN2 TO 1.
              set AutoValList[item][tag] to ABS(AutoValList[item][tag]).
            }
            if updn2 > 0 {
              if not AutoLst[opt][UPDN2][item]:contains(AutoLst[opt][UPDN][item][cnt]) AutoLst[opt][UPDN2][item]:ADD(AutoLst[opt][UPDN][item][cnt]).
              set AutoLst[opt][UPDN][item][cnt] to 0. 
              break.
            }
            set cnt to cnt+1.
        }
      }
    }

     if trm = 1{
            if AutoItemLst[opt][1]:contains(item) {IF AutotagLstUP[item]:length   = 0 AutoItemLst[opt][1]:remove(AutoItemLst[opt][1]:find(item)).}
            if AutoItemLst[opt][2]:contains(item) {IF   AutotagLstDN[item]:length = 0 AutoItemLst[opt][2]:remove(AutoItemLst[opt][2]:find(item)).}
            if AutoItemLst[opt][3]:contains(item) {IF AutotagLstNAUP[item]:length = 0 AutoItemLst[opt][3]:remove(AutoItemLst[opt][3]:find(item)).}
            if AutoItemLst[opt][4]:contains(item) {IF AutotagLstNADN[item]:length = 0 AutoItemLst[opt][4]:remove(AutoItemLst[opt][4]:find(item)).}
     }




      IF AutoLst[opt][updn][item]:LENGTH > 1 AND AutoLst[opt][updn][item]:CONTAINS(0) AutoLst[opt][updn][item]:REMOVE(AutoLst[opt][updn][item]:SUBLIST(1,AutoLst[opt][updn][item]:LENGTH):FIND(0)+1).
      //IF AutoLst[opt][updn][item]:LENGTH > 1 set AutoLst[opt][updn][item] to DeDup(AutoLst[opt][updn][item]).
    //if RSM = 1 {UpdateAutoTriggers(updn,opt,item,tag). set AutoDspList[item][tag] to 1.} else 
    if RSM = 1 {set AutoDspList[item][tag] to 1.} else 
    if RSM > 1 UpdateAutoTriggers(updn2,OPT,item,tag).
    if item = dcptag set DcpPrtList[tag] to list(0,"").
    set SaveFlag to 1. 
    UpdateAutoMinMax(opt).
      if DbgLog > 1 {
        log2file("        post update triggers").
        log2file("          AutoLst["+opt+"]["+updn+"]["+item+"]    :"+LISTTOSTRING(AutoLst[opt][updn][item]) ).
        if AutotagLstUP[ITEM]:length > 1 log2file("         AutotagLstUP["+ITEM+"]:"+LISTTOSTRING(AutotagLstUP[ITEM]) ).
        if AutotagLstDN[ITEM]:length > 1 log2file("         AutotagLstDN["+ITEM+"]:"+LISTTOSTRING(AutotagLstDN[ITEM]) ).
        if  AutotagLstNAup[ITEM]:length > 1 log2file("        AutotagLstNAup["+ITEM+"]:"+LISTTOSTRING(AutotagLstNAup[ITEM]) ).
        if  AutotagLstNADN[ITEM]:length > 1 log2file("        AutotagLstNADN["+ITEM+"]:"+LISTTOSTRING(AutotagLstNADN[ITEM]) ).
      }
  }
   function TriggerAuto{ //and check auto state
      local parameter LstIN, md, ThrVal, opt is 1, opt2 is 1.
      if DbgLog > 0 {
        if opt2 <> 3 log2file("TRIGGERAUTO md:"+modelong[md]+"("+md+") ThrVal:"+ThrVal+" opt:"+opt+" opt2:"+opt2 ).
        else log2file("CHECKSTATE md:"+modelong[md]+"("+md+") status:"+STATUSOPTS[ThrVal]+"("+thrval+")"+" opt:"+opt+" opt2:"+opt2 ).
        if dbglog > 1 log2file("    LstIN:"+LISTTOSTRING(Lstin)).
      }
      local AbsThr to abs(ThrVal).
      set cnt to 0.   
      local lst2 to list().
      for i in Lstin:sublist(1, Lstin:length) {
          if opt = 1 and AutotagLstUP[i]:length > 0 set lst2 to AutotagLstUP[I]:sublist(0, AutotagLstUP[I]:length).
          if opt = 2 and AutotagLstDN[i]:length > 0 set lst2 to AutotagLstDN[I]:sublist(0, AutotagLstDN[I]:length).
          if lst2:length > 0 for t in lst2 {
            Local savedVal TO AutoValList[I][T].
            local trg to 0. local act to 0. 
            local AbsVal to abs(savedVal).
            if DbgLog > 1 {
              log2file("      "+itemlist[I]+"("+I+") "+prtTagList[i][t]+"("+T+")").
              log2file("        AbsVal:"+AbsVal+" "+" savedVal:"+savedVal+" AbsThr:"+AbsThr).
              log2file("        autoRstList[I][T]:"+autoRstList[I][T]).
              log2file("        AutoRscList[I][T]:"+AutoRscList[I][T]).
            }
            if autoRstList[I][T] > 2 and autoRstList[I][T] - opt = 2 set act to 1.
            if autoRstList[I][T] < 3 set act to 1.
            if AutoDspList[I][T] = md{
              if opt2 = 2{
                if AutoRscList[I][T]<>0{
                  if savedVal > -0.0001 and (ship:resources[RscNum[AutoRscList[I][T]]]:amount/ship:resources[RscNum[AutoRscList[I][T]]]:capacity*100) > autolst[md][opt][I][T]-.0001 set trg to 1.
                  if savedVal <  0.0001 and (ship:resources[RscNum[AutoRscList[I][T]]]:amount/ship:resources[RscNum[AutoRscList[I][T]]]:capacity*100) < autolst[md][opt][I][T]+.0001 set trg to 2.
                }}
                else{
              If opt2 = 3{
                    LOCAL TIMETO TO 999.
                    IF AbsVal < 9{if AbsVal = statusopts:find(ship:status) {set act to 1. set trg to 1.}}
                    ELSE{
                           IF AbsVal = 9  set timeto to eta:apoapsis. 
                      else IF AbsVal = 10 set timeto to ETA:periapsis. 
                      else IF AbsVal = 11 set timeto to ETA:NEXTNODE. 
                      else IF AbsVal = 12 set timeto to ETA:TRANSITION.
                      if timeto < 10 { set act to 1. set trg to 1.}
                    }
                  }
              else{
                if DbgLog > 1 and md <> 14 log2file("       if AbsVal("+AbsVal+") = AbsThr("+AbsThr+") and savedVal("+savedVal+")").
                if AbsVal = AbsThr and savedVal > -0.0001 and savedVal > AbsThr-.0001 set trg to 1.
                if AbsVal = AbsThr and savedVal <  0.0001 and savedVal < 0-AbsThr+.0001 set trg to 2.
              }
            }}
              if trg = opt {if act = 1 ToggleGroup(i,t,AutoTRGList[I][T],1). ClearAuto(i,t,opt,AutoDspList[I][T]). UPDATEHUDOPTS().}
          }
      }
    }
   function listautosettings{
    if dbglog > 0 log2file("LISTING AUTO SETTINGS").
    set loading to 0.
      set BtnActn to 1.
      desktop().
      local Plst2 is list().
      for i in range(1,itemlist[0]+2){plst2:add(list(0)).}
      for md in range (1,MODESHRT:LENGTH){
        for u in range(1,5){
          if u = 5 {
          }
          else{
          if u = 1 {set ud to "  OVER ". SET LS TO autotaglstup.}
          if u = 2 {set ud to " UNDER ". SET LS TO autotaglstdn.}
          if u = 3 {set ud to "  OVER ". SET LS TO AutotagLstNAUP.}
          if u = 4 {set ud to " UNDER ". SET LS TO AutotagLstNADN.}
            for i in range(1,autoitemlst[md][u]:length){
              local icnt to 1.
              set itm to autoitemlst[md][u][i].
                if dbglog > 0 log2file("    "+LISTTOSTRING(LS[MD])).
                if ls[md]:length > 0{
                  for t in range(0,ls[itm]:length){
                    local tg to ls[itm][t].
                    IF T <> 0 pout(itm,tg).
                    loadbar().                    
                    set icnt to icnt+1.
                  }
                }
            }
          }
        }
      }
      PRINTLINE("",0,16).
      set LNstp to 1.
     // PRINT "|          | CONTINUE |          |" at (0,18).
      PRINT "|          |          |          |" at (0,18).
        for i in range(1,plst2:length-1){
          if plst2[i]:length > 1{
            for j in range(1,plst2[i]:length){
              local po to printrow(plst2[i][j],0). 
              wait.02.
              if i > plst2:length-2 set po to 1.
              if po = 1 WaitFor(15,1).
            }
          }
          
        }
        if plst2:length > 0 WaitFor(15,1).
            local function pout{
              local parameter itmP,tgP.
              if dbglog > 0 log2file("    "+ItemList[itmp]+":"+prttaglist[itmp][tgp]).
              local automode to abs(AutoDspList[itmP][tgP]).
              LOCAL MODEPRINT TO Removespecial(MODELONG[automode]," "). 
              local wt4 to "".
                local vlprint to abs(AutovalList[ItmP][TgP]).
                local ACTLST to list(4,grpopslist[itmP][tgP][GrpDspList[itmP][tgP]],grpopslist[itmP][tgP][GrpDspList2[itmP][tgP]],grpopslist[itmP][tgP][GrpDspList3[itmP][tgP]], EmptyHud).
                for l in range(1,4){
                  if actlst[l] = EmptyHud set ACTLST[l] to "ACTION"+L.
                }
                LOCAL ActionPrint TO ACTLST[AutoTRGList[itmP][TgP]].
                if ActionPrint:LENGTH > 0 {IF ActionPrint[ActionPrint:LENGTH-1] <> " " SET ActionPrint TO ActionPrint.}
                IF ActionPrint[0] <> " " SET ActionPrint TO " "+ActionPrint.
                set ActionPrint TO " "+Removespecial(ActionPrint," ")+" ".
                SET ActionPrint TO ActionPrint:REPLACE("TURN","TURN ").
                SET ActionPrint TO ActionPrint:REPLACE("RUN","RUN ").
                SET ActionPrint TO ActionPrint:REPLACE("XMIT","XMIT ").
                SET ActionPrint TO ActionPrint:REPLACE("ACTION","ACTION ").
                local afttrgprint to "".
                if autoTRGList[0][itmP][tgP] > 0 {SET DelayPrint TO " WAIT "+autoTRGList[0][itmP][tgP]+" THEN".} ELSE SET DelayPrint TO "".
                if AutoDspList[itmP][tgP] < 0 and AutoDspList[0][itmP][tgP][0]:tostring <> "0"{
                  local splt to AutoDspList[0][itmP][tgP][0]:split("-").
                  if splt:length = 3 set  wt4 to "HOLD4".
                  if splt:length = 4 set  wt4 to "LOCK2".
                }
                if AutoDspList[itmp][TgP] < 0 and AutoDspList[0][itmp][TgP][0] <> 0{
                  local splt to AutoDspList[0][itmp][TgP][0]:split("-").                  
                  set DelayPrint to wt4+REMOVESPECIAL(ItemListHUD[splt[0]:tonumber]," ")+":"+Prttaglist[splt[0]:tonumber][splt[1]:tonumber]+" "+DelayPrint.}
                IF  autoRstList[itmP][tgP] = 1 SET AftTrgPrint TO "DISABLE".
                IF  autoRstList[itmP][tgP] = 2 if UD = " UNDER " { SET AftTrgPrint TO "SWITCH TO OVER".}ELSE{SET AftTrgPrint TO "SWITCH TO UNDER".}.
                IF UD = " UNDER " { SET vlprint TO "UNDER "+vlprint.
                  IF autoRstList[itmP][tgP] = 4 {SET AftTrgPrint TO "WAIT FOR UNDER".}
                  IF autoRstList[itmP][tgP] = 3 {SET ActionPrint TO "RESET ". SET AftTrgPrint TO "WAIT FOR OVER".}
                }
                IF UD = "  OVER " {SET vlprint TO "OVER "+vlprint.
                  IF autoRstList[itmP][tgP] = 3 {SET AftTrgPrint TO "WAIT FOR OVER".}
                  IF autoRstList[itmP][tgP] = 4 {SET ActionPrint TO "RESET ".  SET AftTrgPrint TO "WAIT FOR UNDER".}
                }
                IF MODEPRINT = "ALTAGL" SET MODEPRINT TO "ALT AGL".
                IF MODEPRINT = "STATUS" set vlprint to "is "+ STATUSOPTS[abs(AutoValList[ItmP][TgP])].
                local itmprint to prttaglist[itmP][tgP].
                if itmprint:length > 15 {
                  for wd in trimwords{
                    set itmprint to Removespecial(itmprint,wd).
                  }
                }
                set AftTrgPrint to " THEN "+AftTrgPrint.
                if AftTrgPrint = " THEN DISABLE" set AftTrgPrint to "".
                if Plst2[itmP]:length = 1  and automode <> 1{
                  Plst2[itmP]:add(getcolor(itemlist[itmP],"WHT")).
                }
                local pof to "  "+itmprint+":"+DelayPrint+ActionPrint+"WHEN "+MODEPRINT+" "+vlprint+AftTrgPrint.
                if automode <> 1 and not Plst2[itmP]:contains(pof){Plst2[itmP]:add(pof).
                if dbglog > 0 log2file("    "+pof).
                }
            }
            function WaitFor{
                local parameter wt is 10, opt is 0.
                local wt2 to wt.
                local ch to "".
                //until k2 > wt2-1
                for k2 in range (1,wt2-2){
                  //print "continuing in "+(wt2-k2)+" seconds, or press continue." at (1,16).
                  print "continuing in "+(wt2-k2)+" seconds." at (1,16).
                  //set k2 to k2 +1.
                  ///figure this out
                  if terminal:input:haschar {set ch to terminal:input:getchar().}
                  if ch = "5" {button8a().set ch to "".}
                  wait 1.
                  if k2 > wt2-1 break.
                function button8a{SET k2 to wt2.}buttons:setdelegate(8,button8a@).
                }
              if opt = 1{
                for z in range(1,LNstp+1) print "|"+Bigempty2+"|" at(0,z). 
                set LNstp to 1.
              }     
              //buttons:setdelegate(8,button8@).

              set forcerefresh to 1.
            }
      set BtnActn to 1.
      buttons:setdelegate(8,button8@).
    clearscreen.
    return.
    
    }
    //#endregion
  
    //MAINLOOP
    //#region buttons 
    set v0:wave to "sawtooth".
    
    function button0{if BtnActn=0{set BtnActn to 1. if ENG[1] <> EmptyHud{if hudop = 5{
      set dctnmode to ADDMAX(dctnmode,1,0,2).}
    else{.togglegroup(engtag,enghud[0],1).}}
    set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(0,button0@).
    
    function button1{if BtnActn=0{set BtnActn to 1. if ENG[2] <> EmptyHud{if hudop = 5{
      if dctnmode = 0{
      local lmt to 2. 
      if ModeSel > 7 and modesel < 13 set lmt to 3.
      if modesel > 1 SET AutoValList[0][0][3][modesel] TO CHANGESEL(lmt, AutoValList[0][0][3][modesel] ,"+").
      }
      else{
        SET HDItm TO CHANGESEL(ItemList[0], HDItm ,"+").
        SET HDTag TO 1.
      }
       UPDATEHUDOPTS().}
      else{togglegroup(engtag,enghud[0],2).}}
      set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(1,button1@).
    
    function button2{if BtnActn=0{set BtnActn to 1. if ENG[3] <> EmptyHud{if hudop = 5{
      if dctnmode = 0{
      SET modesel TO CHANGESEL(MODELONG[0], modesel,"+"). 
      until AutoValList[0][0][3][modesel] > -1 {SET modesel TO CHANGESEL(MODELONG[0], modesel,"+").}
      }
      else{
        SET HDTag TO CHANGESEL(HudOpts[2][2][0], HDTag ,"+").
      }
      UPDATEHUDOPTS().}
      else{togglegroup(engtag,enghud[1],1).}}
      set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().
    }buttons:setdelegate(2,button2@).
    
    function button3{if BtnActn=0{set BtnActn to 1. if ENG[4] <> EmptyHud{if hudop = 5{
      if h5mode = 1 set h5mode to 0. else set h5mode to 1.       
      UPDATEHUDOPTS().} //SET delay to ADDMAX(delay,1,0,10).
      else{togglegroup(engtag,enghud[1],2).}}set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(3,button3@).
    
    function button4{if BtnActn=0{set BtnActn to 1. if ENG[5] <> EmptyHud{if hudop = 5{SET AutoRscList[0][EnabSel] TO CHANGESEL(2, AutoRscList[0][EnabSel] ,"+"). UPDATEHUDOPTS().}else{togglegroup(engtag,enghud[2],1).}}set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(4,button4@).
    
    function button5{if BtnActn=0{set BtnActn to 1. if ENG[7] <> EmptyHud{if hudop = 5{SET EnabSel TO CHANGESEL(HudOpts[2][1][0], EnabSel,"+"). PRINT EmptyHud+EmptyHud AT (52,1). UPDATEHUDOPTS().}else{TOGGLE INTAKES.}}set buttonRefresh to 2.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(5,button5@).
    
    function button6{if BtnActn=0{set BtnActn to 1. set buttonRefresh to 1.}set BtnActn to 0. updatehudSlow().}  buttons:setdelegate(6,button6@).
    
    function button7{if BtnActn=0{if PrvITM <> EmptyHud or hudop = 5{
      set BtnActn to 1.set buttonRefresh to 3. set seldir to "-". 
      IF HUDOP = 5{
        if TrgLim > 1 SET AutoSetAct TO CHANGESEL(TrgLim, AutoSetAct,"+").
      }else{
        clearall().
       SET HSEL[2][1] TO CHANGESEL(HudOpts[2][1][0], hsel[2][1],seldir).
        until AutoRscList[0][HSEL[2][1]] = 1 {SET HSEL[2][1] TO CHANGESEL(HudOpts[2][1][0], hsel[2][1],seldir).}
        SET HSEL[2][2] TO 1. 
        SET HSEL[2][3] TO 1.
        set HudOpts[2][2] to prttaglist[hsel[2][1]].
        set HudOpts[2][3] to " ".
        set MtrPrtSel[1] to 0.}
        set forcerefresh to 1.
        UPDATEHUDOPTS().}}set BtnActn to 0.}  buttons:setdelegate(7,button7@).
    
    function button8{
      if BtnActn=0{
        set BtnActn to 1. 
        set buttonRefresh to 1.
        IF HUDOP = 5{
          SET AutoSetMode TO CHANGESEL(MODELONG[0], AutoSetMode,"+").
          until AutoValList[0][0][3][AutoSetMode] = 1 {SET AutoSetMode TO CHANGESEL(MODELONG[0], AutoSetMode,"+").}
        }else{
        if hsel[2][1] = ISRUTag {set hudopts[1][3] to ToggleResConv(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],isruoptlst[ConvRSC],ConvRSC).UPDATEHUDOPTS().}
        else{
          if hsel[2][1] = flytag and ItmTrg = " SET TRGT " {
            IF trglst[anttrgsel] = "no-target" or trglst[anttrgsel] = "active-vessel" return. 
            SET TARGET TO trglst[anttrgsel]. PRINTLINE("target set to:"+ trglst[anttrgsel],"CYN").}
          ELSE{
          if hsel[2][1] = flytag {if hasTarget = FALSE and ItmTrg = " SET TRGT " RETURN.}
          togglegroup(hsel[2][1],hsel[2][2],1).  
        }}}set forcerefresh to 1. UPDATEHUDOPTS().
      }set BtnActn to 0.}  buttons:setdelegate(8,button8@).
    
    function button9{if BtnActn=0{if NXTITM <> EmptyHud{
      set BtnActn to 1. set buttonRefresh to 3. set seldir to "+". 
    IF HUDOP = 5{
      if  abs(AutoSetMode) = 6 {
        if RscSelection =RscList:length-1 {set RscSelection to 0.}
        else{set RscSelection TO CHANGESEL(RscList:length-1,RscSelection,seldir).}
      }
      if abs(AutoSetMode) = 14  set StsSelection TO CHANGESEL(STATUSOPTS[0],StsSelection,"+").
      if  abs(AutoSetMode) = 15 {
        if RscSelection =PRscList:length-1 {set RscSelection to 0.}else{
        set RscSelection TO CHANGESEL(PRscList:length-1,RscSelection,seldir).}
      }
      SET HUDOPPREV TO 0.
    }
    else{
         clearall(). 
        SET HSEL[2][1] TO CHANGESEL(HudOpts[2][1][0], hsel[2][1],seldir).
       until AutoRscList[0][HSEL[2][1]] = 1 {SET HSEL[2][1] TO CHANGESEL(HudOpts[2][1][0], hsel[2][1],seldir). }
        SET HSEL[2][2] TO 1. 
        SET HSEL[2][3] TO 1.
        set HudOpts[2][2] to prttaglist[hsel[2][1]].
        set HudOpts[2][3] to " ".
        set MtrPrtSel[1] to 0.}
        set forcerefresh to 1.
        UPDATEHUDOPTS().
    }}set BtnActn to 0.}  buttons:setdelegate(9,button9@).
    
    function button10{if BtnActn=0{set BtnActn to 1. if BTHD10 <> EmptyHud{
      IF HUDOP = 5{
       set AutoRstMode to CHANGESEL(HudRstMdLst[0],AutoRstMode,"+"). 
       IF  abs(AutoSetMode) = 14 and AutoRstMode > 1 set AutoRstMode to 1.
      }else{
        IF hsel[2][1] = lighttag{SET LOADBKP TO LOADBKP+1.}
        ELSE{
        IF hsel[2][1] = GEARTAG and rowval = 0{SET AUTOBRAKE TO AUTOBRAKE+1. IF AUTOBRAKE = 3 SET AUTOBRAKE TO 0.}
        ELSE{
        if hsel[2][1] = CntrlTag {
          set forcerefresh to 2. 
          if BTHD10 = " TRIM DN  "{
            set trim to trim-1. 
            if trim < (0-TrimMax) set Trim to (0-Trimmax). 
            togglegroup(hsel[2][1],hsel[2][2],4).}
            else{
              set fsel to CHANGESEL(flist[0],FSel,"-"). togglegroup(hsel[2][1],hsel[2][2],3). }}
        else{
           togglegroup(hsel[2][1],hsel[2][2],2).}}}
        set buttonRefresh to 1.}set forcerefresh to 1. UPDATEHUDOPTS().}
    }set BtnActn to 0.}  buttons:setdelegate(10,button10@).
    
    function button11{if BtnActn=0{set BtnActn to 1. if BTHD11 <> EmptyHud{
        IF HUDOP = 5{
          set AutoDspList[hsel[2][1]][hsel[2][2]] to 1.
          SET AutoValList[hsel[2][1]][hsel[2][2]] TO 0.
          SaveAutoSettings(). SETHUD().  UPDATEHUDOPTS().
        }else{
          if hsel[2][1] = CntrlTag{
            set forcerefresh to 2. 
            if BTHD11 = " TRIM UP " {
              set trim to trim+1. 
              if trim > TrimMax set Trim to Trimmax. 
              togglegroup(hsel[2][1],hsel[2][2],4).}
              else{
                set fsel to CHANGESEL(flist[0],FSel,"+"). togglegroup(hsel[2][1],hsel[2][2],3).}
          }else{
        IF hsel[2][1] = lighttag{SET SAVEBKP TO SAVEBKP+1.}
        else{
          if hsel[2][1] = RBTTag and not prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("ModuleRoboticController"){
            SET autoRstList[0][0][tagnumcur] TO autoRstList[0][0][tagnumcur]+1. IF autoRstList[0][0][tagnumcur] = 10 SET autoRstList[0][0][tagnumcur] TO 0. set forcerefresh to 1.}
        ELSE{
        if hsel[2][1] = FlyTag and ROWVAL = 1 {IF HSEL[2][2] = 1{
          set axsel to changesel(APaxis[0], axsel,"+").
          if apsel = 1 and axsel > 3 set axsel to 1.
          if apsel = 2 IF axsel < 4 or axsel > 6 set axsel to 4.
          if apsel = 3 and axsel < 7 set axsel to 7.
          set forcerefresh to 1.
        }}
        else{togglegroup(hsel[2][1],hsel[2][2],3).}}}
        set buttonRefresh to 1. set forcerefresh to 1. UPDATEHUDOPTS().}}}
    }set BtnActn to 0.}  buttons:setdelegate(11,button11@).
    
    function button12{if BtnActn=0{}}  buttons:setdelegate(12,button12@).
    
    function button13{if BtnActn=0{}}  buttons:setdelegate(13,button13@).
    
    function button14{if BtnActn=0{}}  buttons:setdelegate(14,button14@).
    
    function button15{if BtnActn=0{}}  buttons:setdelegate(15,button15@).
    
    function buttonUp{if BtnActn=0{set BtnActn to 1. 
      IF HUDOP = 5{
        if abs(AutoSetMode) = 14 {set StsSelection TO CHANGESEL(STATUSOPTS[0],StsSelection,"+").}
        else{
          if h5mode = 1 {SET setdelay to ADDMAX(setdelay,AutoAdjByLst[AUTOHUD[1]],0,100000,3).}
          else{
          SET AUTOHUD[0] to ADDMAX(AUTOHUD[0],AutoAdjByLst[AUTOHUD[1]],0,1000000000,3).
          }}
      }
      else{if RowSel < 2 {set RowSel to RowSel + 1 - rowval+1. set buttonRefresh to 2.set forcerefresh to 1. set botrow to bigempty2.}
      }UPDATEHUDOPTS(). 
    }.set BtnActn to 0. set forcerefresh to 1.}  buttons:setdelegate(-3,buttonUp@).
    
    function buttonDown{if BtnActn=0{set BtnActn to 1. 
      IF HUDOP = 5{
        if abs(AutoSetMode) = 14 {set StsSelection TO CHANGESEL(STATUSOPTS[0],StsSelection,"-").}
        else{
            if h5mode = 1 {SET setdelay to ADDMAX(setdelay,0-AutoAdjByLst[AUTOHUD[1]],0,100000,3).}
        else{
          SET AUTOHUD[0] to ADDMAX(AUTOHUD[0],0-AutoAdjByLst[AUTOHUD[1]],0,1000000000,3).
          SET HUDOPPREV TO 0.
          }}
      }
      else{if RowSel > 1 {set RowSel to RowSel - 1. set buttonRefresh to 2. set forcerefresh to 1. set botrow to bigempty2.}
      }UPDATEHUDOPTS(). 
    }.set BtnActn to 0. set forcerefresh to 1.}  buttons:setdelegate(-4,buttonDown@).
    
    function buttonLeft{if BtnActn=0{set BtnActn to 1.  set buttonRefresh to 1. set seldir to "-".
            IF HUDOP = 5{
              SET HUDOPPREV TO 0.
              IF AUTOHUD[2] = "  OVER "{ SET AUTOHUD[2] TO " UNDER ".}ELSE{
              IF AUTOHUD[2] = " UNDER " SET AUTOHUD[2] TO "  OVER ".}
            }
      else{ clearall(). set forcerefresh to 1.
      if rowval = 0{
        if hsel[2][1] = scitag set scipart to 1.
        local selprv to HSEL[2][2].
        SET HSEL[2][2] TO CHANGESEL(HudOpts[2][2][0], hsel[2][2],seldir). 
        if autoTRGList[0][HSEL[2][1]][hsel[2][2]] < 0{
          until autoTRGList[0][HSEL[2][1]][HSEL[2][2]] > -1 or HSEL[2][2] = selprv{
          SET HSEL[2][2] TO CHANGESEL(HudOpts[2][2][0], hsel[2][2],seldir). 
          }
        }
        SET HSEL[2][3] TO 1.
        set MtrPrtSel[1] to 0.
      }
      if rowval = 1 {
        if hsel[2][1] = WMGRtag {getEvAct(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],"MissileFire","previous weapon",20).}else{
        if hsel[2][1] = ISRUTag {set ConvRSC to changesel(isruoptlst[0], ConvRSC,seldir).
          set hudopts[1][3] to ToggleResConv(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],isruoptlst[ConvRSC],ConvRSC,2).}else{
        if hsel[2][1] = anttag{set anttrgsel to changesel(trglst[0], anttrgsel,seldir).}else{
        if hsel[2][1] = CntrlTag {if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("ModuleAeroSurface") set CSaxis[0] to 2. else set CSaxis[0] to 3.
          set axsel to changesel(CSaxis[0], axsel,seldir). set forcerefresh to 1.}else{
        if hsel[2][1] = RCSTag {set Raxsel to changesel(RCSaxis[0], Raxsel,seldir). set forcerefresh to 1.}else{
        if hsel[2][1] = scitag {set scipart to changesel(SciDsp:length,scipart,seldir).}else{
        if hsel[2][1] = DcpTag  {set RscSelection TO CHANGESEL(PRscList:length-1, RscSelection,seldir,0).
        }else{
        if hsel[2][1] = EngTag  {adjust_thrust(PrtList[engtag][hsel[2][2]],5,seldir).}else{
        if hsel[2][1] = RBTTag  {
          if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("ModuleRoboticController"){
            getEvAct(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],"ModuleRoboticController","Play Speed",40, plspd-5).}
          else{adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, MtrCur[5], hsel[2][1],  MtrCur[0], MtrCur[1]). set forcerefresh to 1.}
          }else{
        if  hsel[2][1] = GearTag {
          if MtrCur[2] = -1 {togglegroup(hsel[2][1],hsel[2][2],4).}
          else{
          adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 4, hsel[2][1],  MtrCur[0], MtrCur[1]).}}else{
        if hsel[2][1] = BDPTag  {adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 1, hsel[2][1],  MtrCur[0], MtrCur[1]).}else{
        if hsel[2][1] = chutetag{adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 4, hsel[2][1],  MtrCur[0], MtrCur[1]).}else{
        if hsel[2][1] = FlyTag  {
          set HdngSet[0][(axsel)] to ADDMAX(HdngSet[0][(axsel)],-AutoAdjByLst[AUTOHUD[1]], HdngSet[2][(axsel)], HdngSet[1][(axsel)]).
          if ItmTrg = " SET TRGT " set anttrgsel to changesel(trglst[0], anttrgsel,seldir).
        }else{
        if mks =1{ 
          if hsel[2][1] = pwrTag  {adjust_thrust(prtlist[hsel[2][1]][hsel[2][2]],0.1,seldir,2).}else{
          if hsel[2][1] = MksDrlTag  {adjust_thrust(prtlist[hsel[2][1]][hsel[2][2]],0.1,seldir,2).}
        }
        }}}}}}}}}}}}}}

      }if mks =1{set forcerefresh to 2.}
      } UPDATEHUDOPTS().}.set BtnActn to 0.}  buttons:setdelegate(-5,buttonLeft@).
    
    function buttonRight{if BtnActn=0{set BtnActn to 1. set buttonRefresh to 1. set seldir to "+".
      IF HUDOP = 5{SET AUTOHUD[1] TO CHANGESEL(AutoAdjByLst[0],AUTOHUD[1],seldir). SET HUDOPPREV TO 0. SET forcerefresh TO 1.
      }
      else{ clearall(). set forcerefresh to 1.
      if rowval = 0 {
        if hsel[2][1] = scitag set scipart to 1.
        local selprv to HSEL[2][2].
        SET HSEL[2][2] TO CHANGESEL(HudOpts[2][2][0], hsel[2][2],seldir). 
        if autoTRGList[0][HSEL[2][1]][hsel[2][2]] < 0{
          until autoTRGList[0][HSEL[2][1]][HSEL[2][2]] > -1 or HSEL[2][2] = selprv{
          SET HSEL[2][2] TO CHANGESEL(HudOpts[2][2][0], hsel[2][2],seldir). 
          }
        }
        SET HSEL[2][3] TO 1.
        set MtrPrtSel[1] to 0.
      }
      if rowval = 1 {
        if hsel[2][1] = WMGRtag {if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("MissileFire") if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:getmodule("MissileFire"):hasaction("next weapon") prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:GETMODULE("MissileFire"):doaction("next weapon", True).}else{
        if hsel[2][1] = ISRUTag {
          set ConvRSC to changesel(isruoptlst[0], ConvRSC,seldir).
          set hudopts[1][3] to ToggleResConv(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],isruoptlst[ConvRSC],ConvRSC,2).
        }else{
        if hsel[2][1] = anttag {set anttrgsel to changesel(trglst[0], anttrgsel,seldir).}else{
        if hsel[2][1] = CntrlTag {set axsel to changesel(CSaxis[0], axsel,seldir).  set forcerefresh to 1.}else{
        if hsel[2][1] = RCSTag {set Raxsel to changesel(RCSaxis[0], Raxsel,seldir). set forcerefresh to 1.}else{
        if hsel[2][1] = scitag {set scipart to changesel(SciDsp:length,scipart,seldir).}else{
        if hsel[2][1] = DcpTag  {set RscSelection TO CHANGESEL(PRscList:length-1, RscSelection,seldir,0).
        }else{
        if hsel[2][1] = EngTag  {adjust_thrust(PrtList[engtag][hsel[2][2]],5,seldir).}else{
        if hsel[2][1] = RBTTag {
          if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("ModuleRoboticController"){
            getEvAct(prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]],"ModuleRoboticController","Play Speed",40, plspd+5).}
          else{adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, MtrCur[5], hsel[2][1],  MtrCur[0], MtrCur[1]). set forcerefresh to 1.}}else{
        if  hsel[2][1] = GearTag {
          if MtrCur[2] = -1 {togglegroup(hsel[2][1],hsel[2][2],4).}
          else{
          adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 4, hsel[2][1],  MtrCur[0], MtrCur[1]).}}
          else{
        if hsel[2][1] = BDPTag  {adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 1, hsel[2][1],  MtrCur[0], MtrCur[1]).}else{
        if hsel[2][1] = chutetag{adjust_Meter(prtlist[hsel[2][1]][hsel[2][2]], MtrCur[2], seldir, 4, hsel[2][1],  MtrCur[0], MtrCur[1]).}else{
        if hsel[2][1] = FlyTag  {
          set HdngSet[0][(axsel)] to ADDMAX(HdngSet[0][(axsel)],AutoAdjByLst[AUTOHUD[1]], HdngSet[2][(axsel)], HdngSet[1][(axsel)]).
          if ItmTrg = " SET TRGT " set anttrgsel to changesel(trglst[0], anttrgsel,seldir).
          }else{
        if mks =1{set forcerefresh to 2. if hsel[2][1] = pwrTag  {adjust_thrust(prtlist[hsel[2][1]][hsel[2][2]],0.1,seldir,2).}else{
            if hsel[2][1] = MksDrlTag  {adjust_thrust(prtlist[hsel[2][1]][hsel[2][2]],0.1,seldir,2).}else{
            }}
        }}}}}}}}}}}}}}
      }if mks =1{set forcerefresh to 2.}} UPDATEHUDOPTS().}.set BtnActn to 0.}  buttons:setdelegate(-6,buttonRight@).
    
    function buttonEnter{if BtnActn=0{set BtnActn to 1. 
        IF HUDOP = 5{
          local adl to  abs(AutoSetMode).
          if adl > 4 and adl < 8  if AUTOHUD[0] > 100 set autohud[0] to 100.
          if adl = 6 {set autoRscList[hsel[2][1]][hsel[2][2]] to  RscList[RscSelection][0].} 
          if adl = 14 {SET AUTOHUD[0] to StsSelection. SET AUTOHUD[2] TO "  OVER ". }
          if adl = 15 {if PRscList:length > 0 set autoRscList[hsel[2][1]][hsel[2][2]] to  RscSelection.} 
            SET AutoValList[hsel[2][1]][hsel[2][2]] to  AUTOHUD[0].
            set AutoTRGList[hsel[2][1]][hsel[2][2]] to AutoSetAct.
            set autoRstList[hsel[2][1]][hsel[2][2]] TO AutoRstMode.
            set AutoTRGList[0][hsel[2][1]][hsel[2][2]] to setdelay.
            local rmstring to hsel[2][1]+"-"+hsel[2][2]+"-"+0.
            LOCAL rmstring2 to hsel[2][1]+"-"+hsel[2][2]+"-"+-1.
            for rmstring3 in list(rmstring,rmstring2){
              if AutoDspList[0][HDItmB][HDTagB]:contains (rmstring3) AutoDspList[0][HDItmB][HDTagB]:remove  (AutoDspList[0][HDItmB][HDTagB]:find(rmstring3)).
              if AutoDspList[0][HDItm][HDTag]:contains   (rmstring3) AutoDspList[0][HDItm][HDTag]:remove     (AutoDspList[0][HDItm][HDTag]:find(rmstring3)).
            }
            if dctnmode > 0 {
              set AutoDspList[hsel[2][1]][hsel[2][2]] to 0-abs(AutoSetMode).
              if dctnmode = 2 {
                if not AutoDspList[0][HDItm][HDTag]:contains(rmstring2) {AutoDspList[0][HDItm][HDTag]:add(rmstring2).}
                ELSE if not AutoDspList[0][HDItm][HDTag]:contains(rmstring)  {AutoDspList[0][HDItm][HDTag]:add(rmstring). }
              }
              local mde to 1-dctnmode.
                set AutoDspList[0][hsel[2][1]][hsel[2][2]][0] to HDItm+"-"+HDtag+"-"+mde.
                set AutoDspList[hsel[2][1]][hsel[2][2]] TO 1.
            } 
            else{
                set AutoDspList[hsel[2][1]][hsel[2][2]] to abs(AutoSetMode).
                set AutoDspList[0][hsel[2][1]][hsel[2][2]][0] to 0.
              }
               set h5mode to 0.
              SET AutoDspList[0][HDItm][HDTag] TO DEDUP(AutoDspList[0][HDItm][HDTag]).
              SET AutoDspList[0][HDItmB][HDTagB] TO DEDUP(AutoDspList[0][HDItmB][HDTagB]).
            
          IF AUTOHUD[2] = " UNDER " {SET UpDnOut to 2. SET AutoValList[hsel[2][1]][hsel[2][2]] TO 0-AUTOHUD[0].}else{SET UpDnOut to 1.  SET AutoValList[hsel[2][1]][hsel[2][2]] TO AUTOHUD[0].}
          IF dbglog > 0 {
              log2file("SAVE AUTO TRIGGER:"+ItemList[hsel[2][1]]+":"+prtTagList[hsel[2][1]][hsel[2][2]]).
              logauto(1).
          }
          SaveAutoSettings().
          SETHUD(). 
          UpdateAutoTriggers(UpDnOut,abs(AutoDspList[hsel[2][1]][hsel[2][2]]),hsel[2][1],hsel[2][2],1).
          set buttonRefresh to 1. UPDATEHUDOPTS().
        }
        else{
     if rowval = 1 {
      if hsel[2][1] = anttag {if prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:hasmodule("ModuleRTAntenna") prtlist[hsel[2][1]][hsel[2][2]][hsel[2][3]]:getmodule("ModuleRTAntenna"):SETFIELD("target", trglst[anttrgsel]).UPDATEHUDOPTS().}else{
      if hsel[2][1] = CntrlTag {togglegroup(hsel[2][1],hsel[2][2],2).}else{
      if hsel[2][1] = RCSTag {
        local ans to "". 
        local pl to prtlist[hsel[2][1]][hsel[2][2]].
        set pl to pl:sublist(1, pl:length).
            getEvAct(pl[0],"ModuleRCSFX","show actuation toggles",10).
            if getEvAct(pl[0],"ModuleRCSFX",RCSaxis[Raxsel],30) = False set ans to True. else set ans to False.
            if ans <> "" {
              for p in Pl {
            getEvAct(p,"ModuleRCSFX","show actuation toggles",10).
            getEvAct(p,"ModuleRCSFX",RCSaxis[Raxsel],40, ans).
            }
            UPDATEHUDOPTS().
            }
      }else{
      if hsel[2][1] = RBTtag or hsel[2][1] = BDPtag or hsel[2][1] = Geartag or hsel[2][1] = chutetag{
        set MtrCur[5] TO CHANGESEL(MtrCur[4],MtrCur[5],"+",MtrCur[3]).
        }else{
        if  hsel[2][1] = SciTag{togglegroup(hsel[2][1],hsel[2][2],4).
        }else{
        if  hsel[2][1] = Flytag{
          IF hsel[2][2] = 1 {
            local lmt to 3.
            if axsel > 3 set lmt to AutoAdjByLst[0].
            SET AUTOHUD[1] TO CHANGESEL(lmt,AUTOHUD[1],"+").
          }
        }else{
        if mks = 1 {
          if hsel[2][1] = PWRtag {if HDXT = "BAY " {set BaySel TO CHANGESEL(BayLst[0],BaySel,"+"). }}
        }}}}}}}
        SET forcerefresh TO 1. UPDATEHUDOPTS().}
    }
    }. set BtnActn to 0.}  buttons:setdelegate(-1,buttonEnter@).
    
    function buttonCancel{if BtnActn=0{set BtnActn to 1. 
    IF HUDOP = 5{
      SET AUTOHUD TO AUTOHUDBK. SETHUD().
        IF dbglog > 0 {
            log2file("CANCEL EDIT AUTO TRIGGER "+ItemList[hsel[2][1]]+":"+prtTagList[hsel[2][1]][hsel[2][2]]).
            logauto().
            clearto(1,16). 
        }
      }
      ELSE{
        if hudop < 7 {
          SET HUDOP TO 5.
          set h5mode to 0.
          set RscSelection to 0.
          SET AUTOHUDBK TO AUTOHUD. clearto(1,14).  clearall().
          SET AUTOHUD[0] TO ABS(AutoValList[hsel[2][1]][hsel[2][2]]).
          if autoRscList[hsel[2][1]][hsel[2][2]]<>0{set RscSelection to safekey(RscNum,autoRscList[hsel[2][1]][hsel[2][2]]) .}
          set setdelay to AutoTRGList[0][hsel[2][1]][hsel[2][2]].
          set AutoSetMode to abs(AutoDspList[hsel[2][1]][hsel[2][2]]).
          if AutoDspList[hsel[2][1]][hsel[2][2]] > 0  set dctnmode to 0. else  {set dctnmode to 1.}
          if AutoDspList[0][hsel[2][1]][hsel[2][2]][0] <> 0 {
            local splt to AutoDspList[0][hsel[2][1]][hsel[2][2]][0]:split("-").
            set HDItm to splt[0]:tonumber. set HDItmB to HDItm.
            set HDTag to splt[1]:tonumber. set HDTagB to HDTag.
            if splt:length = 4 set dctnmode to 2.
          }
          set AutoSetAct to AutoTRGList[hsel[2][1]][hsel[2][2]].
          set AutoRstMode to autoRstList[hsel[2][1]][hsel[2][2]].
          if AutoValList[hsel[2][1]][hsel[2][2]] > 0 SET UDO TO 1. ELSE SET UDO TO 2.
          ClearAuto(hsel[2][1],hsel[2][2],UDO,AutoDspList[hsel[2][1]][hsel[2][2]],1).
            IF dbglog > 0 {
                log2file("EDIT AUTO TRIGGER "+ItemList[hsel[2][1]]+":"+prtTagList[hsel[2][1]][hsel[2][2]]).
              logauto().
          }
        }else{if  hsel[2][1] = Flytag set apsel TO CHANGESEL(aplim,apsel,"+"). set forcerefresh to 1.}
      }
    set buttonRefresh to 1.UPDATEHUDOPTS().}.set BtnActn to 0.}  buttons:setdelegate(-2,buttonCancel@).
    
    function button16{if BtnActn=0{set BtnActn to 1. SET isDone to 1.}.set BtnActn to 0.}  buttons:setdelegate(13,button16@).
    //#endregion buttons
    local ch to "".
    until isDone > 0 {

      IF kuniverse:timewarp:issettled = TRUE {
        IF WARP > 0 AND WARPMODE = "RAILS" SET THRTFIX TO 1.
        IF THRTFIX = 1 {
          IF WARP < 1{
            UNTIL ship:control:pilotmainthrottle = THRTPREV {SET ship:control:pilotmainthrottle TO THRTPREV.}
            SET THRTFIX TO 0.
            if dbglog > 0 log2file("POST WARP THROTTLE SET TO "+THRTPREV).
          }
        }
        ELSE{if warp = 0 SET THRTPREV TO ship:control:pilotmainthrottle.}
      }
      IF PRINTQ:LENGTH > 0 {if printpause = 0 PrintTheQ(). set refreshRateSlow to 2. IF PRINTQ:LENGTH > 1 set refreshRateSlow to 1.}
      if TIME:SECONDS - refreshTimer2 > refreshRateSlow-.01{
        if saveflag = 1 {
          //if alltagged:length <> ship:ALLTAGGEDPARTS():length partcheck(). 
          if STATUSSAVE:CONTAINS(SHIP:STATUS) or time:seconds-checktime > 90 SaveAutoSettings().
          }
        UPDATESTATUSROW(). 
        SET refreshTimer2 to TIME:SECONDS.
        set printpause to 0.
        IF PRINTQ:LENGTH = 0 set refreshRateSlow to RFSBAak.
      }
      local hdchk to  HdngSet[3][4]+ HdngSet[3][5]+ HdngSet[3][6].
      IF steeringmanager:enabled = TRUE if hdchk <> 0 if abs(SteeringManager:ANGLEERROR) < 5 ap().
      SET VSPDPRV TO SHIP:verticalspeed.
      SET SPDPRV TO SHIP:VELOCITY:SURFACE:MAG.
      set ALTPRV to ship:altitude.
      

    //#region check auto
    if steeringmanager:enabled = True and sas = true unlock steering.
    IF AUTOBRAKE = 0 SET BRAKES TO FALSE. ELSE
    IF AUTOBRAKE = 1 SET BRAKES TO TRUE. ELSE
    IF AUTOBRAKE = 2 {
      IF  SHIP:status = "LANDED" or SHIP:status = "PRELAUNCH"{IF THROTTLE > 0.4999{SET BRAKES TO FALSE.}ELSE{SET BRAKES TO TRUE.}}else{SET BRAKES TO FALSE.}
    }
    if RunAuto = 0{
      LOCAL SWAP TO 0.
      if IsPayload[1] = core:part{SET SWAP TO 1.}
      else{if IsPayload[1]:isdecoupled = True SET SWAP TO 1.}
      if SWAP = 1 {
        SET RunAuto TO 1.
        set refreshRateSlow to autovallist[0][0][4][0].
        set refreshRateFast to autovallist[0][0][4][1].        
        for i in range(1,10){PRINTLINE("CONTROL ENABLING IN "+10-I+" SECONDS   ","WHT"). WAIT 1.}
        ISRUcheck().
         PRINTLINE("",0,14).
      }
    }
    else{
       if HUDOP <> 5 AND RUNAUTO = 1{

      local trg to 0. 
      //check auto spd.
      if checkautotrigger(SpdTrgsUP)  <> 0{
        set trg to min(SpdTrgsUP[0],SpdTrgsUP[1]). 
        if trg = 0 set trg to SpdTrgsUP[1]. 
        if trg <> 0 and SHIP:VELOCITY:SURFACE:MAG > trg  {TriggerAuto(AutoitemLst[2][1],2,trg,1).
        }
      }
      if checkautotrigger(SpdTrgsDN)  <> 0{
        set trg to max(SpdTrgsDN[0],SpdTrgsDN[1]). 
        if trg = 0 set trg to SpdTrgsDN[0]. 
        if trg <> 0 and SHIP:VELOCITY:SURFACE:MAG < trg  {TriggerAuto(AutoitemLst[2][2],2,trg,2).
        }
      }
      //check auto ALT.
      if checkautotrigger(ALTTrgsUP)  <> 0{
        set trg to min(ALTTrgsUP[0],ALTTrgsUP[1]). 
        if trg = 0 set trg to ALTTrgsUP[1]. 
        if ship:altitude > trg  {TriggerAuto(AutoitemLst[3][1],3,trg,1).
        }
      }
      if checkautotrigger(ALTTrgsDN)  <> 0{
        set trg to max(ALTTrgsDN[0],ALTTrgsDN[1]). 
        if trg = 0 set trg to ALTTrgsDN[0]. 
        if ship:altitude < trg  {TriggerAuto(AutoitemLst[3][2],3,trg,2).
        }
      }
      //check auto AGL.
      if checkautotrigger(AGLTrgsUP)  <> 0{
        set trg to min(AGLTrgsUP[0],AGLTrgsUP[1]). 
        if trg = 0 set trg to AGLTrgsUP[1]. 
        if ALT:RADAR > trg  {TriggerAuto(AutoitemLst[4][1],4,trg,1).
        }
      }
      if checkautotrigger(AGLTrgsDN)  <> 0{
        set trg to max(AGLTrgsDN[0],AGLTrgsDN[1]). 
        if trg = 0 set trg to AGLTrgsDN[0]. 
        if ALT:RADAR < trg{TriggerAuto(AutoitemLst[4][2],4,trg,2).
        }
      }
      //check auto EC.
      if checkautotrigger(ECTrgsUP)  <> 0{
        set trg to min(ECTrgsUP[0],ECTrgsUP[1]). 
        if trg = 0 set trg to ECTrgsUP[1]. 
        if round(ship:electriccharge/ecmax*100,0) > trg  {TriggerAuto(AutoitemLst[5][1],5,trg,1).
        }
      }
      if checkautotrigger(ECTrgsDN)  <> 0{
        set trg to max(ECTrgsDN[0],ECTrgsDN[1]). 
        if trg = 0 set trg to ECTrgsDN[0]. 
        if round(ship:electriccharge/ecmax*100,0) < trg  {TriggerAuto(AutoitemLst[5][2],5,trg,2).
        }
      }
      //check auto Rsc.
      if  checkautotrigger(RscTrgsUP) <> 0 {
        set trg to min(RscTrgsUP[0],RscTrgsUP[1]). 
        if trg = 0 set trg to RscTrgsUP[1]. 
        TriggerAuto(AutoitemLst[6][1],6,trg,1,2).
      }
      if  checkautotrigger(RscTrgsDN) <> 0 {
        set trg to max(RscTrgsDN[0],RscTrgsDN[1]). 
        if trg = 0 set trg to RscTrgsDN[0]. 
        TriggerAuto(AutoitemLst[6][2],6,trg,2,2).
      }
      //check auto throttle.
      if  checkautotrigger(ThrtTrgsUP) <> 0 {
        set trg to min(ThrtTrgsUP[0],ThrtTrgsUP[1]). 
        if trg = 0 set trg to ThrtTrgsUP[1]. 
        IF THROTTLE > (TRG*.01) TriggerAuto(AutoitemLst[7][1],7,trg,1,1).
      }
      if  checkautotrigger(ThrtTrgsDN) <> 0 {
        set trg to max(ThrtTrgsDN[0],ThrtTrgsDN[1]). 
        if trg = 0 set trg to ThrtTrgsDN[0]. 
        IF THROTTLE < (TRG*.01) TriggerAuto(AutoitemLst[7][2],7,trg,2,1).
      }
      //check auto Pressure.
      if senselist[3] = 1{
        if  checkautotrigger(PresTrgsUP) <> 0 {
          set trg to min(PresTrgsUP[0],PresTrgsUP[1]). 
          if trg = 0 set trg to PresTrgsUP[1]. 
          IF SHIP:SENSORS:PRES > TRG TriggerAuto(AutoitemLst[8][1],8,trg,1,1).
        }
        if  checkautotrigger(PresTrgsDN) <> 0 {
          set trg to max(PresTrgsDN[0],PresTrgsDN[1]). 
          if trg = 0 set trg to PresTrgsDN[0]. 
          IF SHIP:SENSORS:PRES < TRG TriggerAuto(AutoitemLst[8][2],8,trg,2,1).
        }
      }
      //check auto Sun.
      if senselist[2] = 1{
        if  checkautotrigger(SunTrgsUP) <> 0 {
          set trg to min(SunTrgsUP[0],SunTrgsUP[1]). 
          if trg = 0 set trg to SunTrgsUP[1]. 
          IF SHIP:SENSORS:LIGHT > (TRG*.01) TriggerAuto(AutoitemLst[9][1],9,TRG,1,1).
        }
        if  checkautotrigger(SunTrgsDN) <> 0 {
          set trg to max(SunTrgsDN[0],SunTrgsDN[1]). 
          if trg = 0 set trg to SunTrgsDN[0]. 
          IF SHIP:SENSORS:LIGHT < (TRG*.01) TriggerAuto(AutoitemLst[9][2],9,TRG,2,1).
        }
      }
      //check auto Temp.
      if senselist[4] = 1{
        if checkautotrigger(TempTrgsUP) <> 0 {
          set trg to min(TempTrgsUP[0],TempTrgsUP[1]). 
          if trg = 0 set trg to TempTrgsUP[1]. 
          IF SHIP:SENSORS:TEMP > TRG TriggerAuto(AutoitemLst[10][1],10,trg,1,1).
        }
        if checkautotrigger(TempTrgsDN) <> 0 {
          set trg to max(TempTrgsDN[0],TempTrgsDN[1]). 
          if trg = 0 set trg to TempTrgsDN[0]. 
          IF SHIP:SENSORS:TEMP < TRG TriggerAuto(AutoitemLst[10][2],10,trg,2,1).
        }
      }
      //check auto Grav.
      if senselist[1] = 1{
        if checkautotrigger(GravTrgsUP) <> 0 {
          set trg to min(GravTrgsUP[0],GravTrgsUP[1]). 
          if trg = 0 set trg to GravTrgsUP[1]. 
          IF round(ship:sensors:grav:mag,1) > (TRG*.01) TriggerAuto(AutoitemLst[11][1],11,TRG,1,1).
        }
        if checkautotrigger(GravTrgsDN) <> 0 {
          set trg to max(GravTrgsDN[0],GravTrgsDN[1]). 
          if trg = 0 set trg to GravTrgsDN[0]. 
          IF round(ship:sensors:grav:mag,1) < (TRG*.01) TriggerAuto(AutoitemLst[11][2],11,TRG,2,1).
        }
      }
      //check auto ACC.
      if senselist[0] = 1{
        if checkautotrigger(ACCTrgsUP) <> 0 {
          set trg to min(ACCTrgsUP[0],ACCTrgsUP[1]). 
          if trg = 0 set trg to ACCTrgsUP[1]. 
          IF round(ship:sensors:acc:mag,1) > (TRG*.01) TriggerAuto(AutoitemLst[12][1],12,TRG,1,1).
        }
        if checkautotrigger(ACCTrgsDN) <> 0 {
          set trg to max(ACCTrgsDN[0],ACCTrgsDN[1]). 
          if trg = 0 set trg to ACCTrgsDN[0]. 
          IF round(ship:sensors:acc:mag,1) < (TRG*.01) TriggerAuto(AutoitemLst[12][2],12,TRG,2,1).
        }
      }
      //check auto TWR.
        if checkautotrigger(TWRTrgsUP) <> 0 {
          set trg to min(TWRTrgsUP[0],TWRTrgsUP[1]). 
          if trg = 0 set trg to TWRTrgsUP[1]. 
          IF twr > (TRG*.01) TriggerAuto(AutoitemLst[13][1],13,TRG,1,1).
        }
        if checkautotrigger(TWRTrgsDN) <> 0 {
          set trg to max(TWRTrgsDN[0],TWRTrgsDN[1]). 
          if trg = 0 set trg to TWRTrgsDN[0]. 
          IF twr < (TRG*.01) TriggerAuto(AutoitemLst[13][2],13,TRG,2,1).
        }
      //check auto Status. 

        if SHIP:status <> ShipStatPREV2  OR MAX(StsTrgsUP[0],StsTrgsUP[1])>8{
          if checkautotrigger(StsTrgsUP) <> 0 {
            set trg to min(StsTrgsUP[0],StsTrgsUP[1]).
            if trg = 0 set trg to StsTrgsUP[1].
            if AutoitemLst[14][1]:length > 1 {IF StsTrgs:contains(statusopts:find(ship:status)) OR MAX(StsTrgsUP[0],StsTrgsUP[1])>8{TriggerAuto(AutoitemLst[14][1],14,TRG,1,3).}else{set ShipStatPREV2 to SHIP:status.}}
          }
          //if checkautotrigger(StsTrgsDN) <> 0 { 
          //  set trg to max(StsTrgsDN[0],StsTrgsDN[1]). 
          //  if trg = 0 set trg to StsTrgsDN[0]. 
          //  if AutoitemLst[14][2]:length > 1 and AutoitemLst[14][2]:contains(statusopts:find(ship:status)){TriggerAuto(AutoitemLst[14][2],14,TRG,2,3).}else{set ShipStatPREV2 to SHIP:status.}
          //}
        }
      //check Auto fuel 
      if dcptag <> 0 {if checkautotrigger(FuelTrgsDN) <> 0 OR checkautotrigger(FuelTrgsUP) <> 0 CheckDcpFuel().}  
    
    } //#endregion
      }
      //#region refresh 
      IF loadattempts > 0 and buttonRefresh > 0 and TIME:SECONDS-boottime > 30{set loadattempts to -1.  sendboot().}
      if buttonRefresh > 0 updatehudSlow().
      IF BUTTONREFRESH > 1 {if forcerefresh = 0 SET FORCEREFRESH TO 1.}
      IF BUTTONREFRESH > 2 updatehudSlow().
      if SHIP:status <> ShipStatPREV UPDATEHUDOPTS().
      if TIME:SECONDS - refreshTimer > refreshRateFast-.01 or buttonRefresh > 0 {
        updatehudFast(). 
        if prtcount <> SHIP:PARTS:LENGTH {set saveflag to 1.}.
        SET refreshTimer to TIME:SECONDS.
        set buttonRefresh to 0.
        if forcerefresh > 0 UPDATEHUDOPTS(). 
        if forcerefresh = 2 UPDATEHUDOPTS().
        set forcerefresh to 0.
      }   
      if ActionQNew:length > 0 {
        local acqrm to list().
        LOCAL AACQ TO ActionQNew:COPY.
        local np to list(99,99,99,99).
        for n in AACQ {
          if n[3] = 0 and np[3] = 0 and n[1] = np[1] and n[2] = np[2] {acqrm:add(n).}
          else{
            if n[0] < time:seconds{
              set BtnActn to 1. 
              ToggleGroup(n[1],n[2],n[3],2).
              acqrm:add(n).
              set BtnActn to 0. 
            }
          }
          set np to n.
        }
        for n in acqrm {if ActionQNew:contains(n) ActionQNew:remove(ActionQNew:find(n)).}
        UPDATESTATUSROW().
      }
      if  buttonRefresh = 3 {UPDATESTATUSROW(). SET refreshTimer2 to TIME:SECONDS.}
      //#endregion
      //#region terminal
      if terminal:input:haschar {if BtnActn = 0 set ch to terminal:input:getchar().}
      if ch = "6"  {buttonRight().set ch to "".}
      if ch = "4"  {buttonLeft().set ch to "".}
      if ch = "8"  {buttonUp().set ch to "".}
      if ch = "2"  {buttonDown().set ch to "".}
      if ch = "7"  {button7().set ch to "".}
      if ch = "1" and  BtnActn = 0 {button10().set ch to "".}
      if ch = "9"  {button9().set ch to "".}
      if ch = "3" and  BtnActn = 0 {button11().set ch to "".}
      if ch = "5" and  BtnActn = 0 {button8().set ch to "".}
      if ch = "+"  {set ch to "".}      
      if ch = "-"  {set ch to "".}
      wait 0.001.
      //#endregion terminal
    }
    //clearscreen.
	}

}
function logauto{
  LOCAL parameter OPT IS 0.
  local dl to "".
  local av to "".
  local at to "".
  local ar to "".
  local MD to "".

  IF OPT = 1{
    SET av to " SET TO "+AUTOHUD[0].
    set at to " SET TO "+AutoSetAct.
    set ar TO " SET TO "+AutoRstMode.
    set DL TO " SET TO "+ setdelay.
    set MD to " SET TO "+abs(AutoSetMode).
  }
  log2file("    AutoValList[hsel[2][1]][hsel[2][2]](TRG VALUE  ):"+AutoValList[hsel[2][1]][hsel[2][2]]+AV).
  log2file("    AutoTRGList[hsel[2][1]][hsel[2][2]](ACTION     ):"+AutoTRGList[hsel[2][1]][hsel[2][2]]+" - "+actnlist[AutoTRGList[hsel[2][1]][hsel[2][2]]]+AT).
  log2file("    autoRstList[hsel[2][1]][hsel[2][2]](RESET MODE ):"+autoRstList[hsel[2][1]][hsel[2][2]]+" - "+HudRstMdLst[autoRstList[hsel[2][1]][hsel[2][2]]]+AR).
  log2file("    AutoDspList[hsel[2][1]][hsel[2][2]](AUTO MODE  ):"+AutoDspList[hsel[2][1]][hsel[2][2]]+" - "+MODELONG[abs(AutoDspList[hsel[2][1]][hsel[2][2]])]+MD).
  log2file("    AutoTRGList[0][hsel[2][1]][hsel[2][2]](DELAY   ):"+AutoTRGList[0][hsel[2][1]][hsel[2][2]]+dl).
  if AutoDspList[0][hsel[2][1]][hsel[2][2]][0] <> 0 log2file("    AutoDspList[0][hsel[2][1]][hsel[2][2]][0](WAIT4):"+AutoDspList[0][hsel[2][1]][hsel[2][2]][0]).
  if AutoDspList[hsel[2][1]][hsel[2][2]] = 6 {
    log2file("    autoRscList[hsel[2][1]][hsel[2][2]](RSC SEL    ):"+autoRscList[hsel[2][1]][hsel[2][2]]+" - "+RscList[autoRscList[hsel[2][1]][hsel[2][2]]][0]).
  }
  if AutoDspList[hsel[2][1]][hsel[2][2]] = 15 AND PRscList:LENGTH > 0{
    log2file("    autoRscList[hsel[2][1]][hsel[2][2]](RSC SEL    ):"+autoRscList[hsel[2][1]][hsel[2][2]]+" - "+PRscList[autoRscList[hsel[2][1]][hsel[2][2]]][0]).
  }
  if AutoDspList[hsel[2][1]][hsel[2][2]] < 0 and AutoDspList[0][hsel[2][1]][hsel[2][2]][0]:tostring <> "0"{
    if HDItm <> HDItmB or HDTag <> HDTagB {
      log2file("    AutoDspList[0][HDItmB][HDTagB](WAIT 4 GRP OUT  ):"+AutoDspList[0][HDItmB][HDTagB]+" - "+REMOVESPECIAL(ItemListHUD[HdItmb]," ")+":"+Prttaglist[HdItmb][hdtagb]).
      log2file("    AutoDspList[0][HDItm][HDTag]( WAIT 4 GROUP IN  ):"+AutoDspList[0][HDItm][HDTag]+ " - "+ REMOVESPECIAL(ItemListHUD[HdItm]," ")+":"+Prttaglist[HdItm][hdtag]).
    }if AutoDspList[0][hsel[2][1]][hsel[2][2]][0] <> 0 {
    local splt to AutoDspList[0][hsel[2][1]][hsel[2][2]][0]:split("-").
    if splt:length = 3 log2file( "WONT START DETECTION UNTIL AFTER "+REMOVESPECIAL(ItemListHUD[HdItm]," ")+":"+Prttaglist[HdItm][hdtag]+" IS TRIGGERED").
    if splt:length = 4 log2file( "WILL TRIGGER WHEN "+REMOVESPECIAL(ItemListHUD[HdItm]," ")+":"+Prttaglist[HdItm][hdtag]+" IS TRIGGERED").
    }
  }
}
//#region AP
function AP{// if up 2 fast not turning dn
        local spd to SHIP:VELOCITY:SURFACE:MAG.
        IF SHIP:verticalspeed > VSPDPRV SET VrtDIR TO 1. ELSE SET VrtDIR TO -1.
        IF spd                >  SPDPRV SET SpdDIR TO 1. ELSE SET SpdDIR TO -1.
        IF ship:altitude      >  ALTPRV SET AltDIR TO 1. ELSE SET AltDIR TO -1.
        IF HdngSet[0][4] > 0 set HLIM to HdngSet[0][4]. ELSE set HLIM to HLIMSTRT.
        local altprob to 0.
        set AltSet to HdngSet[0][5].
        IF SHIP:altitude > AltSet set altprob to 1.
        IF SHIP:altitude < AltSet set altprob to -1.
        IF HdngSet[0][6] > 0 SET VLIM TO HdngSet[0][6]. ELSE SET VLIM TO VLIMSTRT.
        IF HdngSet[0][7] > 0 set plim to HdngSet[0][7]. ELSE set plim to PLIMSTRT.
        IF HdngSet[0][8] > 0 set LLIM to HdngSet[0][8]. ELSE set LLIM to LLIMSTRT.
        //LOCAL MLT TO min(ABS(SHIP:verticalspeed)/VLIM,1).
        local mlt to 1.
        local PitchCur to ROUND(compass_and_pitch_for()[1],0).
        LOCAL PitchTrg TO HdngSet[0][2].
        local plimcur to plim.//+plimadj.
        local ptset to abs(PitchCur)+ABS(flyadj[2]).//+plimadj.
        local vprob to 0. if abs(SHIP:verticalspeed) > VLIM*MLT set vprob to 1.
        local ndir to 1.     if PitchCur < 0 set ndir to -1.
        local spdprob to 0.
        if ship:control:pilotmainthrottle < .05 and spd > Hlim and PitchCur < 0 set spdprob to 1.
        if ship:control:pilotmainthrottle > .95 and spd < llim*1.05 and SpdDIR=-1 set spdprob to -1.
        local plimprob to 0. if plimcur < PitchCur set plimprob to 1.
        IF HdngSet[3][4] > 0 { //speed
          local thradj to 3*(1-(min(spd,HLIM)/max(spd,HLIM))).
          local spdclose to 0.
          if GetRange(spd, HdngSet[0][4],10) {set spdclose to 1. set thradj to thradj * 2.}
          IF SpdDIR = 1 {
            IF spd > HLIM Throtadj(ship:control:pilotmainthrottle-thradj).
            if ship:control:pilotmainthrottle = 1 and not spdclose = 1 and PitchCur < plimcur+1 and spdprob > 0 pitchadj(01).//set plimadj to min(plimadj+1,0).
          }
          ELSE{
            if ship:control:pilotmainthrottle = 1 {if PitchCur > 0 and not spdclose = 1 and spdprob <  0 pitchadj(-01).}// set plimadj to plimadj-1.}
            else{ if spd < HLIM Throtadj(ship:control:pilotmainthrottle+thradj).}
          }
        }
        IF HdngSet[3][5] > 0 {//alt          
            local adj to 3.
            if GetRange(SHIP:altitude, AltSet,2)  {set adj to 1. set plimcur to plim/10.}else{
            if GetRange(SHIP:altitude, AltSet,5)  {set adj to 1. set plimcur to plim/6.}else{
            if GetRange(SHIP:altitude, AltSet,10) {set adj to 1. set plimcur to plim/3.}else{
            if GetRange(SHIP:altitude, AltSet,15) {set adj to 2. set plimcur to plim/2.}}}}
            set plim to ceiling(plim).
            if plimcur < PitchCur set plimprob to 1.
            IF altprob = 1 {IF plimprob = 0 and vprob = 0                  {IF DBGLOG > 1  log2file(" ALT CHK 1 DN"). pitchadj(0-adj).} else {IF DBGLOG > 1  log2file(" ALT CHK 1 UP"). pitchadj(adj).  }}
            IF altprob =-1 {IF plimprob = 0 and spdprob > -1 or  vprob = 1 {IF DBGLOG > 1  log2file(" ALT CHK 2 UP"). pitchadj(adj).}   else {IF DBGLOG > 1  log2file(" ALT CHK 2 DN"). pitchadj(0-adj).}}
          }
        IF HdngSet[3][6] > 0 {if abs(SHIP:verticalspeed) > VLIM pitchadj(-AltDIR).}

        function pitchadj{
          local parameter amt is 1.
          SET flyadj[2] TO flyadj[2]+amt.
          if ndir > 0 if flyadj[2]+PitchTrg > plimcur {  set flyadj[2] to plimcur-PitchTrg.  IF DBGLOG > 0  log2file(" LIM ADJ UP").}
          if ndir < 0 if flyadj[2]+PitchTrg < 0-plimcur {set flyadj[2] to 0-plimcur-PitchTrg. IF DBGLOG > 0  log2file(" LIM ADJ DN").}
          IF DBGLOG > 1 if amt > 0 LogAP("    PITCH ADJ UP: "+amt). else LogAP("    PITCH ADJ DN:"+amt).
        }
        function Throtadj{
          local parameter st.
          SET ship:control:pilotmainthrottle TO st.
          IF DBGLOG > 0 log2file("   THRTL SET TO: "+st).
        }
        function LogAP{
          local parameter str is "".
          if str <> "" log2file(str).
          log2file("      THROTTLE:"+ship:control:pilotmainthrottle).
          log2file("      SPEED:"+round(spd,0)+" spdlim:"+Hlim+" spdmin:"+LLIM).
          log2file("      ALTITUDE:"+round(ship:altitude,0)+" ALTSET:"+ HdngSet[0][5]).
          log2file("      VERTICAL SPEED:"+round(ship:VERTICALSPEED,0)+" VLIM:"+vlim+" MLT:"+round(mlt,2)+" VLIM*MLT:"+round(VLIM*MLT,2)).
          log2file("      VrtDIR:"+VrtDIR+"  SpdDIR:"+SpdDIR+"  AltDIR:"+AltDIR).
          log2file("      PITCH:"+PitchCur+" PLimCur:"+plimcur+" PTSET:"+HdngSet[0][2]+" PADJ:"+FLYADJ[2]).//+" Padj2:"+plimadj).
          log2file("      spdprob:"+spdprob+" vprob:"+vprob+" altprob:"+altprob+" plimprob:"+plimprob).
          log2file("      hdngset[3]:"+LISTTOSTRING(hdngset[3])).
        }
    }
//#endregion

//#region string ops
function clearall{
  PRINTLINE("",0,15).  PRINTLINE("",0,16).  PRINTLINE().
}
FUNCTION GetColor{ //GetColor("STR", "RED")
  local parameter StrIn, clr is "GRN", opt is 1.
  local colp to "". local colpo to "".
  if clr = 0 set clr to "GRN".
  if clr = 3 set clr to "ORN".
  if clr = 2 set clr to "RED".
  if clr = 1 set clr to "CYN".
  if colorprint > 0 {
    if FindCl:HASKEY(clr) {
      IF StrIn:LENGTH > widthlim-20 SET OPT TO 0.
      if opt = 1 set colpo to "{COLOR}".
      set colp to  FindCl[clr].
    }
  }else return StrIn.
  return colp+StrIn+colpo.
}
function PrintTheQ{
  local PLN to PRINTQ:POP:split("<sp>").
  PRINTLINE(PLN[0],PLN[1]).
  IF dbglog > 1 log2file("PRINT:"+PLN[0]).
  set printpause to 1.
  set refreshTimer2 to TIME:SECONDS.
}
FUNCTION char_to_ascii {
      local PARAMETER chr.
      LOCAL ascii IS " !\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~".
      RETURN ascii:INDEXOF(chr).
    }
FUNCTION Removespecial{
  local parameter input, toRemove IS "%".
  if input:typename = "String"{
    if toRemove = "%" {set input to input:REPLACE(toRemove, " Percent").}else{
    set input to input:REPLACE(toRemove, "").}}
  return input.
}
function formatTime{
  local parameter t, OP IS 0.
  IF T < 0 RETURN "PASSED".
  local h is 0.
  local dy is 0.
  local ans is "".
  local m is floor(t/60). 
  local s is floor(t-m*60).
  if m > 60 {
    set h to floor(m/60).
    set m to floor(m-(h*60)).
  }
   if h > 24 {
    set dy to floor(h/24).
    set h to floor(h-(dy*24)).
  }
    if dy> 0  set ans to ans+"0"+d + "DY:".
    if h > 0  set ans to ans+"0"+h + ":". else IF OP = 1 set ans to ans+ "00:".
    if FLOOR(m) > 9 set ans to ans+ m. else set ans to ans+ "0" + m.
    if FLOOR(s) > 9 set ans to ans+ ":" + s. else set ans to ans+ ":0" + s.
  return ans.
}
function log2file{
  local parameter str.
  log formattime(time:seconds-boottime,1)+":  "+str to DebugLog.
}
FUNCTION PRINTLINE{
LOCAL PARAMETER WORD is "",cl is 0, line is 17.
IF CL = "GRN" SET CL TO 0.
if line <> 14 PRINT BIGEMPTY2 AT (1,line). else PRINT BIGEMPTY AT (1,line).
if word <> "" {
  if colorprint > 0 and cl <> 0 set word to getcolor(word,cl).
  PRINT WORD AT (1,line).}
  if dbglog > 2 {if word <> "" log2file("   PRINTLINE:"+WORD+" AT("+line+")"). else log2file("   CLEARLINE:("++line+")").}
}
function makehud{
  local parameter word.
  until word:length>9{set word to " "+word+" ".}
  if word:length>9 set word to word:substring(0,10).
  return word.
}
FUNCTION RemoveLetters{
  local parameter input,toRemove IS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%:".
  for i in range(0, toRemove:length) {set input to input:REPLACE(toRemove[I], "").}
  return input.
}
function clearrow{
local parameter rownum, OPTN IS 1.
      IF OPTN =1 {
      set HudOpts[rownum][1] to "                              ".
      set HudOpts[rownum][2] to "                    ".
      set HudOpts[rownum][3] to "                              ".
      }
      printline("",0,hudstart-rownum).
}
function clearto{
  local parameter st, end.
   for i in range(st, end) {PRINTLINE("",0,i). PRINT " " AT (0,I).}
}
function safekey{
  local parameter lx, ky.
  if lx:haskey(ky) return lx[ky].
  return 0.
}
function glt{
  local parameter n1,n2.
  if n1 > n2 return "^".
  if n1 < n2 return "v".
  return " ".
}


FUNCTION LISTTOSTRING{
  LOCAL parameter LSTIN.
  if lstin:typename <> "list" set lstin to list(lstin).
  LOCAL ANS TO "".
  FOR ITM IN LSTIN{
    if itm <> "" set ans to ans+itm+",".
  }
  return ans.
}
FUNCTION PADMID{
  LOCAL PARAMETER STRING, AMT.
        LOCAL SP TO (AMT-STRING:LENGTH)/2.
        local sp2 to 0.
        if ceiling(sp)>sp {
          set sp to floor(sp).
          set sp2 to ceiling(sp).
        }
        LOCAL ST TO STRING:PADLEFT(SP+STRING:LENGTH-1).
        SET   ST TO ST:PADRIGHT(SP2+ST:LENGTH+SP).
        RETURN ST.
}
Function DeDup{
  local parameter lstin.
  local lst2 to lstin:copy.
  local lstout is list().
  for it in lst2 if not lstout:contains(it) lstout:add(it).  
  return lstout.
}
//#endregion
//#region get ops
function getstatus{
local parameter Inum, tagnum, optn is 1, row IS 1, rnd is 0.
  local MDL to modulelist[inum].
  local MDL2 to modulelistAlt[inum].
  local MDL3 to modulelistRPT[inum].
  local optn1 to optn*3-2.
  local ans to "        ".
  local p to PRTLIST[inum][tagnum][1].
  IF dbglog > 2 {
    log2file("GETSTATUS-"+itemlist[Inum]+":"+prtTagList[Inum][tagnum]+":"+optn1+" row:"+row+" rnd:"+rnd).
    log2file("     MODULE1:"+LISTTOSTRING(MDL[optn1])+" MODULE2:"+LISTTOSTRING(MDL2[optn1])+" FIELD:"+LISTTOSTRING(MDL3[optn1])).
    }
  if p:hasmodule(MDL[optn1]){
      if p:getmodule(MDL[optn1]):hasFIELD(MDL3[optn1])  {
        set ans to Removespecial(P:GETMODULE(MDL[optn1]):getfield(MDL3[optn1])). 
        set HudOpts[row][1] to MDL3[optn1]. 
        set HudOpts[row][2] to ":".}}
      else{
      if p:hasmodule(MDL2[optn1]){
        if p:getmodule(MDL2[optn1]):hasFIELD(MDL3[optn1]){
          set ans to Removespecial(P:GETMODULE(MDL2[optn1]):getfield(MDL3[optn1])).
          set HudOpts[row][1] to MDL3[optn1]. 
          set HudOpts[row][2] to ":".}}
      }
        IF ANS <> "        "{
        if rnd > 0 set ans to round(ans, rnd).
        IF dbglog > 2 log2file("    "+" ANS:"+ans).
        if rnd = -1  return ans.
        if rnd = -2  return round(ans, 2).
        }
        
        return ans+"                            ".
}
fUNCTION GetMultiModule{
  local parameter PrtIN, GrabFied, ModName is "".
  local count to 0. LOCAL FLDNM TO "".  LOCAL FLDVL TO "". LOCAL TMPLST TO LIST().
    for m in PrtIN:modules{
      LOCAL GetMod TO PrtIN:GETMODULEBYINDEX(count).
        if GetMod:ALLFIELDNAMES:empty {}else{
          if GrabFied = ""{
              SET FLDNM TO GetMod:ALLFIELDNAMES[0].
              IF M:contains(Modname){
                SET FLDVL TO "".
                TMPLST:add(list(fldnm,FLDVL,count,m)). //fieldname, value, index, module
              }
          }else{
              SET FLDNM TO GetMod:ALLFIELDNAMES[0].
              IF FLDNM:contains(GrabFied){
                SET FLDVL TO GetMod:GETFIELD(FLDNM).
                TMPLST:add(list(fldnm,FLDVL,count,m)).
              }
            }
      }
      set count to count+1.
    }
TMPLST:insert(0,TMPLST:length).
return TMPLST.
}
function GetActions{
    local parameter opt, ModList, inum, tnum, optnin, evac, OpYes, OpNo is list("zzz").//return setting,list parts in , inum, tagnum, op 4 list, what to check 1=ac,2=ev,3=fld.
     if DbgLog > 0 and inum <> 0 {log2file("  GETACTIONS:"+ItemList[inum]+":"+prttaglist[inum][tnum]).
      if DbgLog > 1 {
        log2file("     opt:"+opt+" inum:"+inum+" tnum:"+tnum+" optnin:"+optnin+" evac:"+evac ).
        IF opt = "OnOff" {log2file("       On:"+LISTTOSTRING(OpYes)+" Off:"+LISTTOSTRING(OpNo)).}
        else{
          log2file("       OpYes:"+LISTTOSTRING(OpYes) ).
          log2file("       OpNo :"+LISTTOSTRING(OpNo) ).
          log2file("       ModList:"+LISTTOSTRING(ModList) ).
        }
      }
     }
      local ans to 0.
      LOCAL LM TO 0.
      IF EVAC = 0 {SET LM TO 1. set evac to 3.}
      IF EVAC = 5 {SET LM TO 3. set evac to 2.}
      local optn3 to optnin*3.
      local optn2 to optn3-1.
      local optn1 to optn3-2.
      local pm to "".
      local mdl to "".
      local opout1 to "".
      local opout2 to "".
      local evmin to evac.
      local evmax to evac.
      local p to "".
      if evac = 3 {set evmin to 1. set evmax to 2.}
      if inum = 0 set p to tnum. else set p to PrtList[inum][tnum][1].
      for e in range(evmin,evmax+1){
        if ans > 0 break.
        if e > evmax break.
        set evac to e.
        for md in ModList{
          if ship:modulesnamed(md):length > 0 {
            if p:hasmodule(md){
              if evac = 1 set pm to p:getmodule(md):AllEventNames.
              if evac = 2 set pm to p:getmodule(md):AllActionNames.
              if evac = 4 set pm to p:getmodule(md):AllfieldNames.
              for k in pm{if ans > lm break.
                for op in opyes{if ans > 0 break.
                  if op <>"" {
                    if k:contains(op) and getEvAct(p,md,k,e) {
                      IF EVAC = 4 SET opout2 TO p:getmodule(md):GETFIELD(K).
                        set opout1 to k. 
                        set ans to 1.
                        set mdl to md.
                      break.
                    }
                  }
                }
                IF EVAC <> 4 {
                  for op in opno{if ans > LM break.
                    if op <> "" {
                      if k:contains(op) and getEvAct(p,md,k,e) {
                        set opout2 to k.
                        set ans to ans+2.
                        set mdl to md.
                        break.
                      }
                    }
                  }
                }
              }if ans > 0 break.
            }if ans > 0 break.
          }if ans > 0 break.
        }
      }
      if DbgLog > 1 log2file( "       mdl:"+mdl+"-op out1:"+opout1+"-op out2:"+opout2+"-ans:"+ans+"-evac:"+evac+"-PM:"+LISTTOSTRING(PM)).
      if opt = 1 {set modulelist[inum][optn1] to mdl. set modulelist[inum][optn2] to opout1. set modulelist[inum][optn3] to opout2. return ans.}
      if opt = 2 or opt = "Actions"{return list(mdl,opout1,opout2,ans,evac).}
      if opt = 3 or opt = "Modules" return PM.
      if opt = 4 or opt = "OnOff" {if dbglog > 1  log2file("       OnOff:("+ans+")"). return ans.}
      if opt = 5 {set modulelist[inum][optn1] to mdl. set modulelist[inum][optn2] to opout1. set modulelist[inum][optn3] to opout2. return list(mdl,opout1,opout2,ans,evac).}
   }
function getEvAct{
  local parameter p,m,ev, mode, val is 0..
  local ans to "".
  local tname to "".
  if dbglog > 1 log2file("          GETEVACT:"+mode+" PART:"+p+" MODULE:"+m+" EVENT:"+EV).
  if not p:hasmodule(m) {set ans to false. if dbglog > 1 log2file("           NO MODULE:"+m).}else{
  local pm to p:getmodule(m).
  if mode = 1  {set ans to pm:hasevent(ev). set tname to "hasevent:"+EV.}else{
  if mode = 2  {set ans to pm:hasaction(ev).set tname to "hasaction:"+EV.}else{
  if mode = 3  {set ans to pm:hasfield(ev). set tname to "hasfield:"+EV.}else{
  if mode = 4  {set ans to pm:hasfield(ev). set tname to "hasfield:"+EV.}else{
  if mode = 10 {if  pm:hasevent(ev){pm:doevent(ev).        }set tname to "doevent:"+EV. set ans to pm:hasevent(ev). }else{
  if mode = 20 {if pm:hasaction(ev){pm:doaction(ev, True). }set tname to "doaction:"+EV. set ans to pm:hasaction(ev).}else{
  if mode = 30 {if  pm:hasfield(ev){set ans to pm:GETFIELD(ev).}set tname to "getfield:"+EV.}else{
  if mode = 40 {if  pm:hasfield(ev){pm:SETFIELD(ev,val).}set tname to "setfield:"+EV+" TO:"+val.}
  }}}}}}}}
  if dbglog > 1 log2file("                "+tname+" ANS:"+ans).
  return ans.
}
function checkDcp{
local parameter Prt, Word.
local p to PRT:DECOUPLER.
local ans to 0.
local pt to "".
if p <> "none"{
  if p:TAG:tostring:contains(word){set ans to 1. set pt to p.}else{
    until ans=1 or p = "None"{
      set p to p:parent:decoupler.
      if p <> "none"{if p:TAG:tostring:contains(word) set ans to 1. set pt to p.}
    }
  }
}
return list(ans,pt).
}
function getRTVesselTargets {
  IF dbglog > 0 log2file("GET VESSEL TARGETS").
  local parameter opt is 1.
  local availableTargets to list("no-target","active-vessel").
  if opt = 1{availableTargets:add("Mission Control").
  list targets in allTargets.
  for v in allTargets {set targetName to v:NAME.
      if targetName:contains("Ast.") set targetName to "". 
      if targetName:contains("Debris") set targetName to "". 
          if targetName <>"" {availableTargets:add(targetName).}
      }
        LIST BODIES IN bodList.
        for v in bodList {availableTargets:add(v:name).}

}
  availableTargets:insert(0,availableTargets:length).
  IF dbglog > 1 log2file("    "+LISTTOSTRING(availableTargets)).
  return availableTargets.
}
Function GetRange{
  local parameter val, comp, percent, opt is 1.
    local ans is false.
    if val < comp*(1+(percent/100)) and val > comp*(1-(percent/100)) set ans to True.
    if val = comp  set ans to True.
    if opt = 1 return ans.
    if opt = 2 return list(comp*(1-(percent/100)), comp*(1+(percent/100))).
}
//#endregion
//#region file ops
function sendboot{
  IF dbglog > 0 log2file("BOOTLOOPCHECK").
     local P TO PROCESSOR(CORE:PART:TAG).
      if loadattempts < 0 {
        until CORE:MESSAGES:EMPTY{
          SET RECEIVED TO CORE:MESSAGES:POP.
        }
      IF P:CONNECTION:SENDMESSAGE(loadattempts).}
      else{IF P:CONNECTION:SENDMESSAGE(loadattempts).}
    }
function SaveAutoSettings{
  LOCAL parameter OP IS 1, op2 is 1.
  if op2 = 1 partcheck().
  local loadp to 20.  if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
  if op2 = 2 {set loadp to loadp+1. print "." at (loadp,LNstp-1).}
  if dbglog > 0 log2file("SAVE AUTO SETTINGS").
  set saveflag to 0.
  if prtcount <> SHIP:PARTS:LENGTH set prtcount to SHIP:PARTS:LENGTH.
  file_exists().
  set autovallist[0][0][2] to HEIGHT.
  set autovallist[0][0][1] to HdngSet.
  set autoRstList[0][0][0] to AUTOLOCK.
  if defined (HSel) set AutoDspList[0][0][0] to hsel[2][1]. else set  AutoDspList[0][0][0] to 1.
  if defined (hsel) set AutoDspList[0][0][1] to hsel[2][2]. else set  AutoDspList[0][0][1] to 1.
  if loadattempts = -1 and autovallist[0][0][0] > 1001 set autovallist[0][0][0] to 1001.
  local listout to list(AutoDspList, autovallist,itemlist,prttaglist, prtlist, autoRstList, AutoRscList ,AutoTRGList, MONITORID).
  if op = 1 WRITEJSON(listout, SubDirSV + autofile).
  if op = 2 WRITEJSON(listout, SubDirSV + AutofileBAK).
}
function BootLoopFix{
  IF dbglog > 0 log2file("BOOTLOOPFIX").
  desktop().
  set line to 2.
    local refreshTimer to TIME:SECONDS.
    local isdone to 0.
    sendboot().
        print  "                     IT SEEMS LIKE YOU'RE IN A BOOT LOOP.           " at (1,line).set line to line+1.
        print  "                     WOULD YOU LIKE TO DELETE AUTO FILE?            " at (1,line).set line to line+1.
        print "                                                                     " at (1,line).set line to line+1.   
        print "                                    _____                            " at (1,line).set line to line+1.
        print "                                    |- -|                            " at (1,line).set line to line+1.
        print "                                    |O|O|                            " at (1,line).set line to line+1.
        print "                                    | | |                            " at (1,line).set line to line+1.
        print "                                    | | |                            " at (1,line).set line to line+1.
        print "                                    | |_|                            " at (1,line).set line to line+1.
        print "                                    |___                             " at (1,line).set line to line+1.
        print "                                                   " at (1,line).set line to line+1.           
        print "                   SELECTING LOAD WILL PAUSE AUTO TRIGGERS           " at (1,line).set line to line+1.  
        PRINT getcolor(  "  DELETE  |   LOAD   |" ,"RED",0)at (0,18).
        IF file_exists(autofileBAK) PRINT getcolor("| lOAD BKP  |") AT (42,18).
      function button7{print "Settings discarded."at (1,line+1).set line to line+1. wait 1. SET isDone to 1. set loadattempts to -1. sendboot(). IF file_exists(autofile) DELETEPATH(SubDirSV +autofile).}buttons:setdelegate(7,button7@).
      function button8{SET isDone to 1. if loadattempts > 3 {set loadattempts to -1. sendboot().} set RunAuto to 3.}buttons:setdelegate(8,button8@).
      function button10{
        set loadattempts to -1. sendboot().
        SET LOADBKP TO 2.
        SET isDone to 1.
        set refreshTimer to TIME:seconds+1000000.
        }buttons:setdelegate(10,button10@).
      until isDone > 0 {
      if loadattempts > 3 {
        print "Auto Deleting in " + ROUND((10- (TIME:SECONDS - refreshTimer)),0) + " SECONDS      " at (1,17).
        if TIME:SECONDS - refreshTimer > 10 {button7().}}
      else{
          print "                 ONE MORE CYCLE WILL TRIGGER AUTO DELETE OPTION      " at (1,4).
        print "Selecting No and Resetting Monitor Selection in" + ROUND((10- (TIME:SECONDS - refreshTimer)),0) + " SECONDS      " at (1,17).
        if TIME:SECONDS - refreshTimer > 10 {set monitorselected to 0. setmonvis().button8().}
      }
      }
    }
function file_exists{
  parameter fileName is " ".
  cd(proot).
  IF NOT exists(SubDirSV) CREATEDIR(SubDirSV).
  if filename <> "" {
      cd(SubDirSV).
      local fileList is list().
      local found is false.
      list files in fileList.
      for file in fileList {if file = fileName set found to true.}
      //cd(proot).
      if dbglog > 0 log2file("    FILE EXIST?: "+fileName + ": "+found).
    return found.
  }
}
function partcheck{
  local loadp to 27. if colorprint > 0{ set loadp to loadp+9. PRINT " " AT (80,LNstp-1).}
  local parameter opt is 1.
  LOCAL GR TO 0. 
  if alltagged:length <> ship:ALLTAGGEDPARTS():length {fixpl(). set gr to 1.}
  set  PrtListcur to SetPartList(ship:ALLTAGGEDPARTS()).
 // print break(f).
     if DbgLog > 0 log2file("PARTCHECK:"+opt ).
      for i in range (1,itemlist[0]+1){
        local cnt1 to 0.
        IF I = itemlist[0]+1 BREAK.
       if opt > 1 { set loadp to loadp+1. print "." at (loadp,LNstp-1).}
        for t in range (1,prtTAGList[I][0]+1){
            IF OPT = 1 IF I = FLYTAG OR I = AGTAG BREAK.
          IF t = prtTAGList[I][0]+1 BREAK.
          set cnt to 0.
          for p in range (1,prtList[I][T][0]+1){
            if prtList[I][T]:length < p+1 prtList[I][T]:add(CORE:PART).
            IF p = prtList[I][T][0]+1 BREAK.
            if alltagged:length <> ship:ALLTAGGEDPARTS():length {fixpl(). set gr to 1.}
            local validpart to 1.
            if i <> agtag and i <> flyTag {
              if prtList[I][T][P]:typename = "String" {set validpart to 0. 
                if DbgLog > 0 and not lostparts:contains(prtList[I][T][P]:tostring+"-"+CNT) {log2file("        "+ITEMLIST[I]+":"+PRTTAGLIST[I][T]+" REMOVED - IS STRING" ). 
                lostparts:add(prtList[I][T][P]:tostring+"-"+CNT).}
              }else{
              IF prtList[I][T][P]:TAG = ""{set validpart to 0.
                set prtList[I][T][P] to CORE:PART.
                if DbgLog > 0 and not lostparts:contains(prtList[I][T][P]:tostring+"-"+CNT) log2file("       "+ITEMLIST[I]+":"+PRTTAGLIST[I][T]+" REMOVED - PART GONE" ).
                lostparts:add(prtList[I][T][P]:tostring+"-"+CNT).
              }ELSE{
              if prtList[I][T][P] = core:part {
                if not prtList[I][T][P]:tostring:contains("tag="+prttaglist[I][T]:tostring) {set validpart to 0.
                  if DbgLog > 0 and not lostparts:contains(prtList[I][T][P]:tostring+"-"+CNT) log2file("        "+ITEMLIST[I]+":"+PRTTAGLIST[I][T]+" REMOVED - NOT FOUND" ) .
                  lostparts:add(prtList[I][T][P]:tostring+"-"+CNT).
                  }
                }
              }}}
            if DbgLog > 1  log2file("   "+ITEMLIST[i]+"("+i+")"+PRTTAGLIST[i][t]+"("+t+")"+PRTLIST[i][t][p]+"("+p+")-"+validpart ).
            if validpart = 1 and PrtListcur:tostring:contains(prtList[I][T][P]:tostring){
              set cnt1 to 1.
              if opt > 1 {
                if t > autoTRGList[0][I]:length-1 log2file(i+"-"+t+"-"+p).
                if autoTRGList[0][I][T] < 0{
                  if DbgLog > 0 log2file("     "+ITEMLIST[i]+":"+PRTTAGLIST[i][t]+" SET TO RUN").
                  set AutoDspList[I][T] to abs(AutoDspList[I][T]).
                  set autoTRGList[0][I][T] to 0.
                }
              }
            }
            else{
              set gr to 1.
              if DbgLog > 0 and prtList[I][T][P]:tostring <> CORE:PART:tostring.{
                  if not lostparts:contains(prtList[I][T][P]:tostring+"-"+CNT) and validpart = 1{
                    set validpart to 0.
                    log2file("        "+ITEMLIST[I]+":"+PRTTAGLIST[I][T]+" REMOVED - NO TAG ="+prttaglist[I][T]:tostring ).
                    lostparts:add(prtList[I][T][P]:tostring+"-"+CNT).
                  }
              }
              set cnt to cnt+1.
              set prtList[I][T][P] to CORE:PART.
            }
            if i = agtag OR i = flyTag SET CNT TO 0.
            LOCAL PCNT TO prtList[I][T][0].
            IF PCNT:typename = "String" SET PCNT TO PCNT:TONUMBER.
            SET PCNT TO PCNT-1.
            if cnt > PCNT and autoTRGList[0][I][T] > -1{
              set gr to 1.
              if DbgLog > 0 log2file("          TAG:"+ITEMLIST[i]+":"+PRTTAGLIST[i][t]+" SET TO SKIP").
              set autoTRGList[0][I][T] to 0-abs(AutoDspList[I][T])-1.
              set AutoDspList[I][T] to 0-abs(AutoDspList[I][T]).
            }
          }
          //SET CA TO AutoDspList[I][T].
      }
      if i = agtag OR i = flyTag SET CNT1 TO 1.
      if cnt1 = 0 and AutoRscList[0][I] <> 2{
         if DbgLog > 0 log2file("           ITEM:"+ITEMLIST[i]+" SET TO SKIP").
        SET AutoRscList[0][I] to 2.
        //ClearAuto(i,t,opt,CA).
        }
    }
    if gr=1 {
      local rscl to getRSCList(ship:resources,1).
      set rsclist to rscl[0].
      set RscNum to rscl[1].
      set rsclist2 to rscl[2].
    }
}
function addlist{ //delete me when done with old files
IF dbglog > 0 log2file("ADDLIST****************").
  for i in range(1,itemlist[0]+1){
  AutoDspList[0]:add(list(0)).
    for t in range(1,prtTAGList[I][0]+1){
      AutoDspList[0][I]:add(list(0)).
      WAIT 0.001.
    }
  }
  if AutoValList[0][0]:length = 1 AutoValList[0][0]:add(list(3,0,0,0,0,0,0)).
  if AutoValList[0][0]:length = 2 AutoValList[0][0]:add(HEIGHT).
  if AutoValList[0][0]:length = 3 AutoValList[0][0]:add(LIST(15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)).
  if AutoValList[0][0]:length = 4 AutoValList[0][0]:add(LIST(refreshRateSlow,refreshRateFast,debug,dbglog,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)).
  return.
}
function fixpl{
  set PrtListcur to SetPartList(ship:ALLTAGGEDPARTS()). 
  set alltagged to ship:ALLTAGGEDPARTS(). 
}
//#endregion
//#region Borrowed 
function setmonvis{
  if dbglog > 0  log2file("SETMONITOR").
  LOCAL refreshTimer to TIME:SECONDS-2.
  //Initialize local variables
  local isDone to 0.
  local ch to "".
  local totalMonitors to addons:kpm:getmonitorcount().
 
  function selectedMonitor
  {
    local parameter index.
    set buttons:currentmonitor to index.
    set id to addons:kpm:getguidshort(index).
    set monitorGUID to addons:kpm:getguidshort(index).
    set monitorselected to 1.
  }
  //Main loop
  function setmonvismain{
    //buttons:setdelegate(7,button7@).
    local function button13{set isDone to 1. SET MONITORID TO monitorGUID.}
    local function button11{set isDone to 1. SET MONITORID TO "0000000"+ monitorIndex.}
        //buttons:setdelegate(13,button13@).
    CLEARSCREEN.
    ///print UI layout
    print "          |          |   SELECT MONITOR    |          |          |XXXXXXXXXX|" at (0,0).
    print "|          |          |          |          |FORCE NUM |          |  SELECT  |" at (0,20).
    print "TOTAL MONITORS: " + totalMonitors AT (2,1).
    print "INSTRUCTIONS: ALLOW PROGRAM TO CYCLE THROUGH MONITORS, CLICK SELECY"AT (1,5). 
    print "WHEN THE CORRECT MONITOR IS SELECTED THE PROGRAM WILL PROCEED. "AT (1,6).
    print "YOU CAN USE NUMPAD 4 AND 6 TO MANUALLY CYCLE IF KOS WINDOW IS OPEN. "AT (1,7).
    print "SELECT FORCE NUM TO FORCE THIS SHIP TO ALWAYS USE THIS MONITOR NUMBER." AT (1,8).
    IF FORCEMON > 0 print "AUTOSELECT SET TO MONITOR "+(ForceMon-1) AT (1,12).
    //Sub loop
    UNTIL isDone > 0 
    { 
      IF MonAutoCyc = 1 {
        print "CYCLING TO NEXT MONITOR IN " + ROUND((3- (TIME:SECONDS - refreshTimer)),0) + " SECONDS      " at (1,17).

      if TIME:SECONDS - refreshTimer > 3 {
             if forcemon > 0  or totalMonitors = 1{
            if monitorIndex = forcemon-1 or totalMonitors = 1{
              if totalMonitors = 1 set monitorindex to 0.
              set monitorGUID to addons:kpm:getguidshort(monitorIndex). 
              set buttons:currentmonitor to monitorIndex.
              set id to addons:kpm:getguidshort(monitorIndex).
              set monitorselected to 1. 
              PRINT "MONITOR FORCED TO MON "+monitorIndex. break.
            }}
    if totalMonitors = 0{clearscreen. 
    print "CLICK STBY TWICE TO CYCLE SCRIPT." AT (1,1). 
    print "CLICK STBY TWICE TO CYCLE SCRIPT." AT (1,2). 
    print "CLICK STBY TWICE TO CYCLE SCRIPT." AT (1,3).
    print "   CLICK THIS BUTTON TWICE!!!!." AT (1,15). print "<-----------------------" AT (1,16).}
        SET refreshTimer to TIME:SECONDS.
        if monitorIndex < totalMonitors-1{
        set monitorIndex to monitorIndex + 1.
        selectedMonitor(monitorIndex).
        buttons:setdelegate(11,button11@).
        buttons:setdelegate(13,button13@).
        print "              " AT (32,17).
        }else{set monitorIndex to 0.}
      }
      }
      print "CURRENT MONITOR: " + monitorIndex + "     " AT (2,2).
      print "MONITOR ID: " + id+"    " AT (2,3).
      //Numpad listener
      if terminal:input:haschar{set ch to terminal:input:getchar().}
      if ch = "8"{SET ch to "".}
      if ch = "2"{SET ch to "".}
      if ch = "4"{ SET refreshTimer to TIME:SECONDS.
        set MonAutoCyc to 0.
        if monitorIndex > 0{
          set monitorIndex to monitorIndex - 1.
          selectedMonitor(monitorIndex).
          print "              " AT (32,17).
        }
         print "AUTO CYCLE CANCELED                              " at (0,4).
        SET ch to "".
      }
      if ch = "6"{ SET refreshTimer to TIME:SECONDS.
        set MonAutoCyc to 0.
        if monitorIndex < totalMonitors-1{
          set monitorIndex to monitorIndex + 1.
          selectedMonitor(monitorIndex).
          print "              " AT (32,17).
        }
         print "AUTO CYCLE CANCELED                              " at (0,4).
        SET ch to "".
      }
      wait 0.001.
    }
  clearscreen.
  }
  setmonvismain().
}  
function east_for {
  parameter ves is ship.

  return vcrs(ves:up:vector, ves:north:vector).
}
function compass_for {
  parameter ves is ship,thing is "default".
  local pointing is ves:facing:forevector.
  if not thing:istype("string") {
    set pointing to type_to_vector(ves,thing).
  }
  local east is east_for(ves).
  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).
  local result is arctan2(trig_y, trig_x).
  if result < 0 {
    return 360 + result.
  } else {
    return result.
  }
}
function pitch_for {
  parameter ves is ship,thing is "default".
  local pointing is ves:facing:forevector.
  if not thing:istype("string") {
    set pointing to type_to_vector(ves,thing).
  }
  return 90 - vang(ves:up:vector, pointing).
}
function roll_for {
  parameter ves is ship,thing is "default".

  local pointing is ves:facing.
  if not thing:istype("string") {
    if thing:istype("vessel") or pointing:istype("part") {
      set pointing to thing:facing.
    } else if thing:istype("direction") {
      set pointing to thing.
    } else {
      print "type: " + thing:typename + " is not reconized by roll_for".
	}
  }
  local trig_x is vdot(pointing:topvector,ves:up:vector).
  if abs(trig_x) < 0.0035 {//this is the dead zone for roll when within 0.2 degrees of vertical
    return 0.
  } else {
    local vec_y is vcrs(ves:up:vector,ves:facing:forevector).
    local trig_y is vdot(pointing:topvector,vec_y).
    return arctan2(trig_y,trig_x).
  }
}
function compass_and_pitch_for {
  parameter ves is ship,thing is "default".
  local pointing is ves:facing:forevector.
  if not thing:istype("string") {
    set pointing to type_to_vector(ves,thing).
  }
  local east is east_for(ves).
  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).
  local trig_z is vdot(ves:up:vector, pointing).
  local compass is arctan2(trig_y, trig_x).
  if compass < 0 {
    set compass to 360 + compass.
  }
  local pitch is arctan2(trig_z, sqrt(trig_x^2 + trig_y^2)).
  return list(compass,pitch).
}
function bearing_between {
  parameter ves,thing_1,thing_2.
  local vec_1 is type_to_vector(ves,thing_1).
  local vec_2 is type_to_vector(ves,thing_2).
  local fake_north is vxcl(ves:up:vector, vec_1).
  local fake_east is vcrs(ves:up:vector, fake_north).
  local trig_x is vdot(fake_north, vec_2).
  local trig_y is vdot(fake_east, vec_2).
  return arctan2(trig_y, trig_x).
}
function type_to_vector {
  parameter ves,thing.
  if thing:istype("vector") {
    return thing:normalized.
  } else if thing:istype("direction") {
    return thing:forevector.
  } else if thing:istype("vessel") or thing:istype("part") {
    return thing:facing:forevector.
  } else if thing:istype("geoposition") or thing:istype("waypoint") {
    return (thing:position - ves:position):normalized.
  } else {
    print "type: " + thing:typename + " is not recognized by lib_navball".
  }
}
FUNCTION vertical_aoa {
  LOCAL srfVel IS VXCL(SHIP:FACING:STARVECTOR,SHIP:VELOCITY:SURFACE).//surface velocity excluding any yaw component 
  RETURN VANG(SHIP:FACING:FOREVECTOR,srfVel).
}
//#endregion 
