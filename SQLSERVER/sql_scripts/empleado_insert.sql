
    CREATE TRIGGER trg_empleado_insert
    ON empleado
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'empleado', @UsuarioActual, 'INSERT' FROM inserted
    END
    