
    CREATE TRIGGER trg_empleado_update
    ON empleado
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'empleado', @UsuarioActual, 'UPDATE' FROM inserted
    END
    