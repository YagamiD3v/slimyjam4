<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.2" name="mob_bee" tilewidth="18" tileheight="10" tilecount="4" columns="4">
 <image source="sprite/Bee/bee_simple.png" width="72" height="10"/>
 <tile id="0">
  <objectgroup draworder="index" id="2">
   <object id="1" x="0" y="0" width="18" height="10">
    <properties>
     <property name="isCollider" type="bool" value="true"/>
    </properties>
   </object>
  </objectgroup>
  <animation>
   <frame tileid="0" duration="120"/>
   <frame tileid="1" duration="120"/>
   <frame tileid="2" duration="120"/>
   <frame tileid="3" duration="120"/>
  </animation>
 </tile>
</tileset>
