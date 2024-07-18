
    CREATE TRIGGER trg_metodo_pago_delete
    ON metodo_pago
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'metodo_pago', @UsuarioActual, 'DELETE' FROM deleted
    END
    