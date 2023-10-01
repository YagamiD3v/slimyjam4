<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.2" name="coin" tilewidth="16" tileheight="16" tilecount="12" columns="12">
 <editorsettings>
  <export target="coin.lua" format="lua"/>
 </editorsettings>
 <image source="object/coin.png" width="192" height="16"/>
 <tile id="0">
  <objectgroup draworder="index" id="3">
   <object id="2" x="6" y="6" width="4" height="4">
    <properties>
     <property name="isCollider" type="bool" value="true"/>
    </properties>
   </object>
  </objectgroup>
  <animation>
   <frame tileid="0" duration="100"/>
   <frame tileid="1" duration="100"/>
   <frame tileid="2" duration="100"/>
   <frame tileid="3" duration="100"/>
   <frame tileid="4" duration="100"/>
   <frame tileid="5" duration="100"/>
   <frame tileid="6" duration="100"/>
   <frame tileid="7" duration="100"/>
   <frame tileid="8" duration="100"/>
   <frame tileid="9" duration="100"/>
   <frame tileid="10" duration="100"/>
   <frame tileid="11" duration="100"/>
  </animation>
 </tile>
</tileset>
