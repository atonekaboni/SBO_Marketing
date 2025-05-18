-- Created by Amirhossein Tonekaboni, SAP Business One Consultant
-- Date: May 18, 2025
-- Contact: https://linkedin.com/in/atonekaboni
-- Version: 1.0
-- Description: Displays the top 10 recent sales order items for a specific business partner with order status and stock details.
-- Test in a non-production environment before deployment.
-- Licensed under MIT License

SELECT TOP 10 
    T1.ItemCode    AS 'Item No.', 
    T2.ItemName    AS 'Item Name', 
    T1.Quantity    AS 'Quantity', 
    T1.Price       AS 'Price', 
    T0.DocDate     AS 'Order Date', 
    T0.DocNum      AS 'Document Number',
    T2.OnHand      AS 'In Stock',
    (T2.OnHand - T2.IsCommited + T2.OnOrder) AS 'Available', -- Calculate available quantity
    CASE T0.DocStatus
        WHEN 'O' THEN 'Open'
        WHEN 'C' THEN 'Closed'
        WHEN 'L' THEN 'Cancelled'
        ELSE T0.DocStatus
    END AS 'Order Status', -- Sales order status (O=Open, C=Closed, L=Cancelled)
    CASE T2.InvntItem
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
        ELSE T2.InvntItem
    END		AS 'Inventory Item',
    ROW_NUMBER() OVER (ORDER BY T0.DocDate DESC) AS 'Row Number'
FROM ORDR T0
INNER JOIN RDR1 T1 ON T0.DocEntry = T1.DocEntry	-- Join sales order header with line items
INNER JOIN OITM T2 ON T1.ItemCode = T2.ItemCode	-- Join with item master for name, stock, and inventory status
WHERE T0.CardCode = $[$4.0.0]
