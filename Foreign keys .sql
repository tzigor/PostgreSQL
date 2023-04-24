ALTER TABLE users
  ADD CONSTRAINT users_main_photo_id_fk
  FOREIGN KEY (main_photo_id)
  REFERENCES photo (id)
    ON DELETE SET NULL;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
  FOREIGN KEY (from_user_id)
  REFERENCES users (id)
    ON DELETE CASCADE;

ALTER TABLE messages
  ADD CONSTRAINT messages_to_user_id_fk
  FOREIGN KEY (to_user_id)
  REFERENCES users (id)
    ON DELETE CASCADE;

ALTER TABLE video
  ADD CONSTRAINT video_owner_id_fk
  FOREIGN KEY (owner_id)
  REFERENCES users (id)
    ON DELETE CASCADE;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_status_id_fk
  FOREIGN KEY (status_id)
  REFERENCES friendship_statuses (id)
    ON DELETE SET DEFAULT;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_user_id_fk
  FOREIGN KEY (user_id)
  REFERENCES users (id)
    ON DELETE CASCADE;

ALTER TABLE communities
  ADD CONSTRAINT communities_creator_id_fk
  FOREIGN KEY (creator_id)
  REFERENCES users (id)
    ON DELETE CASCADE;

ALTER TABLE photo ADD COLUMN metadata JSON;
UPDATE photo SET metadata = json_build_object(
	'id', id,
	'url', url,
	'size', size
);

ALTER TABLE communities ADD COLUMN members INT [];
UPDATE communities 
  SET members = 
    (SELECT array_agg(user_id) FROM communities_users 
	   WHERE community_id = communities.id)
WHERE id = 3;

CREATE TYPE contacts AS (phone VARCHAR(15), email VARCHAR(120));
ALTER TABLE users ADD COLUMN user_contacts contacts;
UPDATE users SET user_contacts = (users.phone, users.email);
UPDATE users SET user_contacts.email = 'test@email.ru' WHERE id = 21;
