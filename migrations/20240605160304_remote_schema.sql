drop policy "Enable all for authenticated users only" on "public"."interviews";

alter table "public"."interviews" add column "agreement_doc_id" text;

alter table "public"."interviews" add column "agreement_ok" boolean not null default false;

alter table "public"."interviews" add column "audio_split_ok" boolean not null default false;

alter table "public"."interviews" add column "email" text not null;

alter table "public"."interviews" add column "phone" text;

alter table "public"."results" drop column "prediction";

alter table "public"."results" drop column "type";

alter table "public"."results" add column "audio_emotions" jsonb not null;

alter table "public"."results" add column "part" smallint not null;

alter table "public"."results" add column "speaker" smallint;

alter table "public"."results" add column "text" character varying not null;

alter table "public"."results" add column "text_emotions" jsonb not null;

alter table "public"."results" add column "video_emotions" jsonb not null;

alter table "public"."results" alter column "end" set data type double precision using "end"::double precision;

alter table "public"."results" alter column "start" set data type double precision using "start"::double precision;

create policy "Enable all access for all users"
on "public"."interviews"
as permissive
for all
to public
using (true);


create policy "Enable all access for all users"
on "public"."results"
as permissive
for all
to public
using (true);


create policy "Enable all access for all users"
on "public"."sessions"
as permissive
for all
to public
using (true);



