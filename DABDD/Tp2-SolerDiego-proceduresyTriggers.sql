
-- procedimiento para registrar pedidos

DELIMITER $$

CREATE PROCEDURE RegistrarPedido(
    IN p_idcliente INT,
    IN p_idvendedor INT,
    IN p_fecha DATE,
    IN p_detalle JSON -- Detalle en formato JSON con idproducto, cantidad, precio unitario
)
BEGIN
    DECLARE v_error INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error = 1;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Insertar en la tabla Pedidos
    INSERT INTO Pedidos (idcliente, idvendedor, fecha, Estado)
    VALUES (p_idcliente, p_idvendedor, p_fecha, 'Confirmado');

    -- Obtener el NumeroPedido generado
    SET @ultimoPedido = LAST_INSERT_ID();

    -- Iterar por cada renglon del detalle en JSON
    SET @detalle = JSON_UNQUOTE(p_detalle);
    SET @size = JSON_LENGTH(@detalle);
    SET @index = 0;

    WHILE @index < @size DO
        SET @idproducto = JSON_UNQUOTE(JSON_EXTRACT(@detalle, CONCAT('$[', @index, '].idproducto')));
        SET @cantidad = JSON_UNQUOTE(JSON_EXTRACT(@detalle, CONCAT('$[', @index, '].cantidad')));
        SET @precio = JSON_UNQUOTE(JSON_EXTRACT(@detalle, CONCAT('$[', @index, '].precio')));

        -- Insertar el detalle
        INSERT INTO DetallePedidos (NumeroPedido, idproducto, cantidad, PrecioUnitario, Total)
        VALUES (@ultimoPedido, @idproducto, @cantidad, @precio, @cantidad * @precio);

        -- Actualizar el stock del producto
        UPDATE Productos
        SET Stock = Stock - @cantidad
        WHERE idproducto = @idproducto AND Stock >= @cantidad;

        SET @index = @index + 1;
    END WHILE;

    IF v_error = 0 THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END $$

DELIMITER ;


----------------------------------------------------------------
--Procedimiento almacenado para anular un pedido

DELIMITER $$

CREATE PROCEDURE AnularPedido(IN p_numeroPedido INT)
BEGIN
    DECLARE v_error INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error = 1;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el pedido este confirmado
    IF (SELECT Estado FROM Pedidos WHERE NumeroPedido = p_numeroPedido) = 'Confirmado' THEN
        -- Revertir stock de los productos
        UPDATE Productos p
        JOIN DetallePedidos d ON p.idproducto = d.idproducto
        SET p.Stock = p.Stock + d.cantidad
        WHERE d.NumeroPedido = p_numeroPedido;

        -- Actualizar estado del pedido a 'Anulado'
        UPDATE Pedidos
        SET Estado = 'Anulado'
        WHERE NumeroPedido = p_numeroPedido;

        -- Insertar en el log de anulaciones
        INSERT INTO logpedidosanulados (numeroPedido, FechaAnulacion)
        VALUES (p_numeroPedido, NOW());

        IF v_error = 0 THEN
            COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no puede ser anulado porque no está confirmado.';
    END IF;
END $$

DELIMITER ;

----------------------------------------------------------------

--Procedimiento almacenado para actualizar el precio de articulos por origen

DELIMITER $$

CREATE PROCEDURE ActualizarPrecioPorOrigen(
    IN p_origen VARCHAR(50),
    IN p_porcentaje DECIMAL(5, 2)
)
BEGIN
    -- Actualizar precio de los productos del origen indicado
    UPDATE Productos
    SET PrecioUnitario = PrecioUnitario * (1 + (p_porcentaje / 100))
    WHERE origen = p_origen;
END $$

DELIMITER ;


------------------------------------------------------------------
--triggers

DELIMITER $$

CREATE TRIGGER trigger_anulacion_pedido
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    IF OLD.Estado = 'Confirmado' AND NEW.Estado = 'Anulado' THEN
        INSERT INTO logpedidosanulados (numeroPedido, FechaAnulacion)
        VALUES (NEW.NumeroPedido, NOW());
    END IF;
END $$

DELIMITER ;
