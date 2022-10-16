-- Crear un Query para extraer la última actualización de cada shipment
SELECT s.shipmentXid,
	   s.totalWeight ,
	   s.totalWeight_uom_code,
	   s.totalNetVolume, 
	   s.totalVolume_uom_code,
	   s.weightUtilization, 
	   s.volumeUtilization,
	   s.totalShipUnitCount,
	   s.servprovGid,
	   s.destLocationGid,
	   s.plannedCost*20.5 AS 'plannedCost',
	   s.totalActualCost* 20.5 AS 'totalActualCost', 
	   s.totalDeclaredValue*20.5 AS 'totalDeclaredValue', 
	   s.firstEquipmentGroupGid,
	   s.insert_date, 
	   s.LastUpdatedDateTime 
	   FROM shipment s 
	   WHERE  CONCAT(s.shipmentXid,s.LastUpdatedDateTime)  
	   IN (SELECT CONCAT(shipmentXid, MAX(LastUpdatedDateTime)) FROM shipment GROUP BY shipmentXid );

	  -- Verificación de que son distintos  (no es necesario pegar todos los campos para la validación)
WITH CTE1 AS (SELECT s.shipmentXid,
	   s.LastUpdatedDateTime 
	   FROM shipment s 
	   WHERE  CONCAT(s.shipmentXid,s.LastUpdatedDateTime)  
	   IN (SELECT CONCAT(shipmentXid, MAX(LastUpdatedDateTime)) FROM shipment GROUP BY shipmentXid ))
SELECT DISTINCT count(CONCAT(shipmentXid,LastUpdatedDateTime) ) FROM CTE1;

WITH CTE1 AS (SELECT s.shipmentXid,
	   s.LastUpdatedDateTime 
	   FROM shipment s 
	   WHERE  CONCAT(s.shipmentXid,s.LastUpdatedDateTime)  
	   IN (SELECT CONCAT(shipmentXid, MAX(LastUpdatedDateTime)) FROM shipment GROUP BY shipmentXid ))
SELECT count(CONCAT(shipmentXid,LastUpdatedDateTime) ) FROM CTE1;

-- Todos los pesos están medidos en kg 
SELECT DISTINCT	 s.totalWeight_uom_code FROM shipment s;  
-- Todos los volumenes estan en la misma unidad CUMTR
SELECT DISTINCT	 s.totalVolume_uom_code FROM shipment s;  	

-- Crear un Query para extraer los datos de facturaciÃ³n necesarios (invoice) para complementar la informaciÃ³n de cada shipment
SELECT i.invoiceXid,
	   i.consolidationType,
	   i.otherCharge, 
	   i.attribute5,
	   i.dateReceived,
	   i.LastUpdatedDateTime AS 'invLastUpdatedDateTime'
	   FROM invoice i
	  WHERE CONCAT(i.invoiceXid, i.LastUpdatedDateTime)
	  IN (SELECT CONCAT(i2.invoiceXid, MAX(i2.LastUpdatedDateTime)) FROM invoice i2 GROUP BY i2.invoiceXid);
	 


				     
WITH shipmentSim AS (SELECT s.shipmentXid,
	   s.totalWeight ,
	   s.totalWeight_uom_code,
	   s.totalNetVolume, 
	   s.totalVolume_uom_code,
	   s.weightUtilization, 
	   s.volumeUtilization,
	   s.totalShipUnitCount,
	   s.servprovGid,
	   s.destLocationGid,
	   s.plannedCost*20.5 AS 'plannedCost',
	   s.totalActualCost* 20.5 AS 'totalActualCost', 
	   s.totalDeclaredValue*20.5 AS 'totalDeclaredValue', 
	   s.firstEquipmentGroupGid,
	   s.insert_date, 
	   s.LastUpdatedDateTime 
	   FROM shipment s 
	   WHERE  CONCAT(s.shipmentXid,s.LastUpdatedDateTime)  
	   IN (SELECT CONCAT(shipmentXid, MAX(LastUpdatedDateTime)) FROM shipment GROUP BY shipmentXid )),
invoiceSim AS (SELECT i.invoiceXid,
	   i.consolidationType,
	   i.otherCharge, 
	   i.attribute5,
	   i.dateReceived,
	   i.LastUpdatedDateTime AS 'invLastUpdatedDateTime'
	   FROM invoice i
	  WHERE CONCAT(i.invoiceXid, i.LastUpdatedDateTime)
	  IN (SELECT CONCAT(i2.invoiceXid, MAX(i2.LastUpdatedDateTime)) FROM invoice i2 GROUP BY i2.invoiceXid))
SELECT shipmentSim.*, invoiceSim.* FROM shipmentSim
		LEFT JOIN invoiceSim ON invoiceSim.attribute5 = shipmentSim.shipmentXid 
	  


-- Crear un Query para extraer el total por orden (order_release)	
SELECT orr.orderReleaseXid,
	   orr.orderReleaseGid,
	   orr.totalDeclaredValue* 20.5 AS 'totalDeclaredValue', 
	   orr.totalItemPackageCount,
	   orr.LastUpdatedDateTime  AS 'orrLastUpdateDateTime' 
	   FROM order_release orr
	   WHERE CONCAT(orr.orderReleaseXid, orr.LastUpdatedDateTime) 
	   IN (SELECT CONCAT(orr2.orderReleaseXid, MAX(orr2.LastUpdatedDateTime)) FROM order_release orr2 GROUP BY orr2.orderReleaseXid)
	   
									   
-- Crear un Query para extraer los productos por orden (s_ShipunitLine, order_release)
WITH orderReleaseSim AS (SELECT orr.orderReleaseXid,
	   orr.orderReleaseGid,
	   orr.totalDeclaredValue* 20.5 AS 'totalDeclaredValue', 
	   orr.totalItemPackageCount,
	   orr.LastUpdatedDateTime  AS 'orrLastUpdateDateTime' 
	   FROM order_release orr
	   WHERE CONCAT(orr.orderReleaseXid, orr.LastUpdatedDateTime) 
	   IN (SELECT CONCAT(orr2.orderReleaseXid, MAX(orr2.LastUpdatedDateTime)) FROM order_release orr2 GROUP BY orr2.orderReleaseXid))
SELECT orderReleaseSim.*, 
	   ssl.shipUnitGid,
	   ssl.itemPackageCount, 
	   ssl.packagedItemGid, 
	   ssl.declared_value FROM orderReleaseSim 
	   INNER JOIN s_ShipunitLine ssl ON ssl.orderReleaseGid= orderReleaseSim.orderReleaseGid;




-- Crear un Query para extraer los productos enviados en cada shipment (shipmentStopD)    

	
	
