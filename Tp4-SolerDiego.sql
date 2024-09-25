-- Sección 1: Sentencias de creación de procedimientos almacenados de la base de datos.
DELIMITER //
-- Crea un procedimiento almacenado que permita asignar un pedido a un mozo.
CREATE PROCEDURE AsignarPedido(
    IN pedido_id INT,
    IN mozo_id INT
)
BEGIN
    UPDATE pedidos SET IdMozo = mozo_id WHERE IdPedido = pedido_id;
END //
DELIMITER;

DELIMITER //
-- Crea un procedimiento almacenado que permita insertar un nuevo pedido.
CREATE PROCEDURE NuevoPedido(
    IN pedido_id INT,
    IN mozo_id INT,
    IN menu_id INT,
    IN nombre_menu VARCHAR(255),
    IN bebidas_especiales VARCHAR(255),
    IN cantidad_platos INT,
    IN numero_mesa INT,
    IN forma_pago VARCHAR(255)
)
BEGIN
    INSERT INTO Pedido (IdPedido, IdMozo, IdMenu, Menu, BebidasEspeciales, CantidadDePlatos, NumeroDeMesa, FormaDePago)
    VALUES (pedido_id, mozo_id, menu_id, nombre_menu, bebidas_especiales, cantidad_platos, numero_mesa, forma_pago);
END //
DELIMITER;

DELIMITER //
-- Crea un procedimiento almacenado que permita asignar un mozo a otro turno (cambio de turno dentro de la empresa).
CREATE PROCEDURE AsignarMozo(
    IN mozo_id INT,
    IN nuevo_turno VARCHAR(255)
)
BEGIN
    UPDATE Mozo
    SET Turno = nuevo_turno
    WHERE IdMozo = mozo_id;
END //

DELIMITER ;

-- Sección 2: Sentencias de creación de triggers asociados a la tabla en la base de datos.

DELIMITER //

-- Crea un trigger que permita registrar la asignación de un pedido abierto a otro mozo.
CREATE TRIGGER RegistrarCambioMozo AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.IdMozo <> OLD.IdMozo AND OLD.IdMozo IS NOT NULL AND NEW.IdMozo IS NOT NULL THEN
        INSERT INTO CambiosMozo (IdPedido, IdMozoAnterior, IdMozoNuevo)
        VALUES (NEW.IdPedido, OLD.IdMozo, NEW.IdMozo);
    END IF;
END //

DELIMITER ;

-- Sección 3: Sentencias de creación de funciones en la base de datos.

DELIMITER //

-- Crea una función que permita determinar los pedidos cerrados y atendidos por cada mozo y en cada turno.
CREATE FUNCTION ObtenerPedidosCerradosPorMozoYTurno()
RETURNS VARCHAR(255)
BEGIN
    DECLARE resultado VARCHAR(255);
    SET resultado = '';

    SELECT CONCAT('Mozo: ', m.IdMozo, ', Turno: ', m.Turno, ', Cantidad de Pedidos Cerrados: ', COUNT(*))
    INTO resultado
    FROM Mozo m
    INNER JOIN Pedido p ON m.IdMozo = p.IdMozo
    WHERE p.Estado = 'Cerrado'
    GROUP BY m.IdMozo, m.Turno;

    RETURN resultado;
END //

DELIMITER ;
