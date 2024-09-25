-- Crear la tabla Mozos
CREATE TABLE Mozos (
    mozo_id INT PRIMARY KEY,
    apellido VARCHAR(50),
    nombre VARCHAR(50),
    turno INT
);

-- Crear la tabla Mesas
CREATE TABLE Mesas (
    mesa_id INT PRIMARY KEY,
    last_pedido_id INT,
    turno INT
);

-- Crear la tabla Menus
CREATE TABLE Menus (
    menu_id INT PRIMARY KEY,
    detalle VARCHAR(100),
    apellido_cliente VARCHAR(50)
);

-- Crear la tabla Pedidos
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    mozo_id INT,
    mesa_id INT,
    menu_id INT,
    bebidas VARCHAR(100),
    pedido_especial VARCHAR(100),
    cantidad_platos INT,
    forma_pago VARCHAR(50),
    estado VARCHAR(50),
    FOREIGN KEY (mozo_id) REFERENCES Mozos(mozo_id),
    FOREIGN KEY (mesa_id) REFERENCES Mesas(mesa_id),
    FOREIGN KEY (menu_id) REFERENCES Menus(menu_id)
);

-- Crear la tabla RegistroAsignacionesPedidos
CREATE TABLE RegistroAsignacionesPedidos (
    registro_id INT PRIMARY KEY,
    pedido_id INT,
    nuevo_mozo_id INT,
    fecha_asignacion DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (nuevo_mozo_id) REFERENCES Mozos(mozo_id)
);

-- Procedimiento almacenado para asignar un pedido a un mozo
CREATE PROCEDURE AsignarPedido(
    @mozo_id INT,
    @mesa_id INT,
    @menu_id INT,
    @bebidas VARCHAR(100),
    @pedido_especial VARCHAR(100),
    @cantidad_platos INT,
    @forma_pago VARCHAR(50)
)
AS
BEGIN
    INSERT INTO Pedidos (mozo_id, mesa_id, menu_id, bebidas, pedido_especial, cantidad_platos, forma_pago, estado)
    VALUES (@mozo_id, @mesa_id, @menu_id, @bebidas, @pedido_especial, @cantidad_platos, @forma_pago, 'abierto')
END;

-- Procedimiento almacenado para insertar un nuevo pedido
CREATE PROCEDURE InsertarPedido(
    @mozo_id INT,
    @mesa_id INT,
    @menu_id INT,
    @bebidas VARCHAR(100),
    @pedido_especial VARCHAR(100),
    @cantidad_platos INT,
    @forma_pago VARCHAR(50)
)
AS
BEGIN
    DECLARE @pedido_id INT

    INSERT INTO Pedidos (mozo_id, mesa_id, menu_id, bebidas, pedido_especial, cantidad_platos, forma_pago, estado)
    VALUES (@mozo_id, @mesa_id, @menu_id, @bebidas, @pedido_especial, @cantidad_platos, @forma_pago, 'abierto')

    SET @pedido_id = SCOPE_IDENTITY()

    UPDATE Mesas
    SET last_pedido_id = @pedido_id
    WHERE mesa_id = @mesa_id

    SELECT @pedido_id AS nuevo_pedido_id
END;

-- Procedimiento almacenado para asignar un mozo a otro turno
CREATE PROCEDURE AsignarMozoTurno(
    @mozo_id INT,
    @nuevo_turno INT
)
AS
BEGIN
    UPDATE Mozos
    SET turno = @nuevo_turno
    WHERE mozo_id = @mozo_id
END;

-- Trigger para registrar la asignación de un pedido abierto a otro mozo
CREATE TRIGGER RegistroAsignacionPedido
ON Pedidos
AFTER UPDATE
AS
BEGIN
    IF UPDATE(mozo_id)
    BEGIN
        DECLARE @pedido_id INT
        DECLARE @nuevo_mozo_id INT

        SELECT @pedido_id = inserted.pedido_id, @nuevo_mozo_id = inserted.mozo_id
        FROM inserted

        IF EXISTS (SELECT 1 FROM Pedidos WHERE pedido_id = @pedido_id AND estado = 'abierto')
        BEGIN
            INSERT INTO RegistroAsignacionesPedidos (pedido_id, nuevo_mozo_id, fecha_asignacion)
            VALUES (@pedido_id, @nuevo_mozo_id, GETDATE())
        END
    END
END;

-- Función para obtener los pedidos cerrados por mozo y turno
CREATE FUNCTION ObtenerPedidosCerradosPorMozoYTurno(
    @mozo_id INT,
    @turno INT
)
RETURNS TABLE
AS
RETURN
    SELECT p.pedido_id, p.mesa_id, p.menu_id, p.forma_pago
    FROM Pedidos p
    INNER JOIN Mesas m ON p.mesa_id = m.mesa_id
    WHERE p.mozo_id = @mozo_id
    AND m.turno = @turno
    AND p.estado = 'cerrado';
