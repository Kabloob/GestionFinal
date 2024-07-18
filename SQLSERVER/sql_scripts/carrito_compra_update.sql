
    CREATE TRIGGER trg_carrito_compra_update
    ON carrito_compra
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'carrito_compra', @UsuarioActual, 'UPDATE' FROM inserted
    END
    