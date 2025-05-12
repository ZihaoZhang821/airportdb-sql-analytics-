# Prevention of duplicate passport numbers
CREATE TRIGGER trg_passport_unique_check
BEFORE INSERT ON passenger
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM passenger WHERE passport_no = NEW.passport_no
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Passport number already exists!';
  END IF;
END;

# Disable updating of airplane_id
CREATE TRIGGER trg_airplane_id_protect
BEFORE UPDATE ON airplane
FOR EACH ROW
BEGIN
  IF NEW.airplane_id <> OLD.airplane_id THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot change airplane_id!';
  END IF;
END;

# Automatically standardize passenger names to initial capital letters
CREATE TRIGGER trg_capitalize_passenger_name
BEFORE INSERT ON passenger
FOR EACH ROW
BEGIN
  SET NEW.firstname = CONCAT(UCASE(LEFT(NEW.firstname, 1)), LCASE(SUBSTRING(NEW.firstname, 2)));
  SET NEW.lastname = CONCAT(UCASE(LEFT(NEW.lastname, 1)), LCASE(SUBSTRING(NEW.lastname, 2)));
END;
