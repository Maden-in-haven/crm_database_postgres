-- создание клиента
CREATE OR REPLACE FUNCTION create_client(
    p_username VARCHAR,
    p_email VARCHAR,
    p_password_hash VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_phone_number VARCHAR,
    p_address TEXT
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создаем нового пользователя
    INSERT INTO users (username, email, password_hash, role)
    VALUES (p_username, p_email, p_password_hash, 'Client')
    RETURNING id INTO new_user_id;

    -- Создаем запись в таблице клиентов
    INSERT INTO clients (id, first_name, last_name, phone_number, address)
    VALUES (new_user_id, p_first_name, p_last_name, p_phone_number, p_address);

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;

-- Создание администратора
CREATE OR REPLACE FUNCTION create_admin(
    p_username VARCHAR,
    p_email VARCHAR,
    p_password_hash VARCHAR,
    p_permissions JSONB
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создаем нового пользователя
    INSERT INTO users (username, email, password_hash, role)
    VALUES (p_username, p_email, p_password_hash, 'Admin')
    RETURNING id INTO new_user_id;

    -- Создаем запись в таблице администраторов с правами "super_admin"
    INSERT INTO admins (id, permissions)
    VALUES (new_user_id, jsonb_build_object('super_admin', true));

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;

-- Создание менеджера
CREATE OR REPLACE FUNCTION create_manager(
    p_username VARCHAR,
    p_email VARCHAR,
    p_password_hash VARCHAR,
    p_department VARCHAR,
    p_hire_date TIMESTAMP
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создаем нового пользователя
    INSERT INTO users (username, email, password_hash, role)
    VALUES (p_username, p_email, p_password_hash, 'Manager')
    RETURNING id INTO new_user_id;

    -- Создаем запись в таблице менеджеров
    INSERT INTO managers (id, department, hire_date)
    VALUES (new_user_id, p_department, p_hire_date);

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;

