SELECT TOP 1000* FROM shipment;
SELECT TOP 1000* FROM shipmentStopD;
SELECT TOP 1000* FROM invoice;
SELECT TOP 1000* FROM invoice_status;
SELECT TOP 1000* FROM equipment;
SELECT TOP 1000* FROM order_release;
SELECT TOP 1000* FROM customer;
SELECT city, count(*) FROM customer GROUP BY city ORDER BY count(*) DESC;
SELECT equipmentGroupName, count(*), AVG(CAST(effectiveVolume AS FLOAT)) FROM equipment GROUP BY equipmentGroupName ORDER BY count(*) DESC;  

SELECT totalWeight_uom_code, AVG(totalWeight), AVG(totalWeight)*AVG(weightUtilization), AVG(weightUtilization) FROM shipment GROUP BY totalWeight_uom_code;  
SELECT totalVolume_uom_code, AVG(totalNetVolume),AVG(totalNetVolume)*AVG(volumeUtilization), AVG(volumeUtilization)  FROM shipment GROUP BY totalVolume_uom_code;  
SELECT DATEDIFF(day, startTime, endTime), COUNT(*) FROM shipment GROUP BY DATEDIFF(day, startTime, endTime) ORDER BY DATEDIFF(day, startTime, endTime) DESC;
SELECT * FROM shipment WHERE DATEDIFF(day, startTime, endTime)=-179; 

%SELECT * FROM shipment WHERE ( (shipmentXid, updateDate) in (SELECT  (shipmentXid, MAX(updateDate)) FROM shipment GROUP BY shipmentXid) ); 
