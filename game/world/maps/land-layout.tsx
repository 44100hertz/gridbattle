<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.3.1" name="land-layout" tilewidth="16" tileheight="16" tilecount="16" columns="4">
 <image source="land-layout.png" width="64" height="64"/>
 <tile id="0" type="flat">
  <properties>
   <property name="geom" value="flat"/>
   <property name="walk" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="1" type="ladder">
  <properties>
   <property name="geom" value="vertical"/>
   <property name="walk" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="2" type="slope_l">
  <properties>
   <property name="geom" value="slope_l"/>
   <property name="walk" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="3" type="slope_r">
  <properties>
   <property name="geom" value="slope_r"/>
   <property name="walk" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="4" type="water">
  <properties>
   <property name="geom" value="flat"/>
   <property name="swim" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="5" type="bridge">
  <properties>
   <property name="geom" value="flat"/>
   <property name="swim" type="bool" value="true"/>
   <property name="walk" type="bool" value="true"/>
  </properties>
 </tile>
</tileset>
