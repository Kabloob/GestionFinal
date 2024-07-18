
    CREATE TRIGGER trg_carrito_compra_insert
    ON carrito_compra
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'carrito_compra', @UsuarioActual, 'INSERT' FROM inserted
    END
    