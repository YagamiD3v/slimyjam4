<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.2" name="mob_mushroom" tilewidth="16" tileheight="16" tilecount="4" columns="4">
 <editorsettings>
  <export target="mob_mushroom.lua" format="lua"/>
 </editorsettings>
 <image source="sprite/Mushroom/Mushroom_4/Mushroom_4_simple.png" width="64" height="16"/>
 <tile id="0">
  <objectgroup draworder="index" id="3">
   <object id="2" x="0" y="0" width="16" height="16">
    <properties>
     <property name="isCollider" type="bool" value="true"/>
    </properties>
   </object>
  </objectgroup>
  <animation>
   <frame tileid="0" duration="150"/>
   <frame tileid="1" duration="150"/>
   <frame tileid="2" duration="150"/>
   <frame tileid="3" duration="150"/>
  </animation>
 </tile>
</tileset>
