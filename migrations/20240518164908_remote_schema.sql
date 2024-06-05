create type "public"."result_type" as enum ('text', 'video', 'audio');

alter table "public"."interviews" drop constraint "public_interviews_sessionId_fkey";

create table "public"."results" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "interview_id" bigint not null,
    "start" text not null,
    "end" text not null,
    "type" result_type not null,
    "prediction" jsonb not null,
    "user_id" uuid not null
);


alter table "public"."results" enable row level security;

alter table "public"."interviews" drop column "firstName";

alter table "public"."interviews" drop column "lastName";

alter table "public"."interviews" drop column "sessionId";

alter table "public"."interviews" add column "audio_ok" boolean not null default false;

alter table "public"."interviews" add column "diarization_ok" boolean not null default false;

alter table "public"."interviews" add column "first_name" text not null;

alter table "public"."interviews" add column "last_name" text not null;

alter table "public"."interviews" add column "session_id" bigint not null;

alter table "public"."interviews" add column "text_ok" boolean not null default false;

alter table "public"."interviews" add column "user_id" uuid not null;

alter table "public"."interviews" add column "video_ok" boolean not null default false;

alter table "public"."sessions" add column "user_id" uuid not null;

CREATE UNIQUE INDEX interviews_id_key ON public.interviews USING btree (id);

CREATE UNIQUE INDEX results_pkey ON public.results USING btree (id);

CREATE UNIQUE INDEX sessions_id_key ON public.sessions USING btree (id);

alter table "public"."results" add constraint "results_pkey" PRIMARY KEY using index "results_pkey";

alter table "public"."interviews" add constraint "interviews_id_key" UNIQUE using index "interviews_id_key";

alter table "public"."interviews" add constraint "interviews_session_id_fkey" FOREIGN KEY (session_id) REFERENCES sessions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."interviews" validate constraint "interviews_session_id_fkey";

alter table "public"."interviews" add constraint "interviews_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."interviews" validate constraint "interviews_user_id_fkey";

alter table "public"."results" add constraint "results_interview_id_fkey" FOREIGN KEY (interview_id) REFERENCES interviews(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."results" validate constraint "results_interview_id_fkey";

alter table "public"."results" add constraint "results_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."results" validate constraint "results_user_id_fkey";

alter table "public"."sessions" add constraint "sessions_id_key" UNIQUE using index "sessions_id_key";

alter table "public"."sessions" add constraint "sessions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sessions" validate constraint "sessions_user_id_fkey";

grant delete on table "public"."results" to "anon";

grant insert on table "public"."results" to "anon";

grant references on table "public"."results" to "anon";

grant select on table "public"."results" to "anon";

grant trigger on table "public"."results" to "anon";

grant truncate on table "public"."results" to "anon";

grant update on table "public"."results" to "anon";

grant delete on table "public"."results" to "authenticated";

grant insert on table "public"."results" to "authenticated";

grant references on table "public"."results" to "authenticated";

grant select on table "public"."results" to "authenticated";

grant trigger on table "public"."results" to "authenticated";

grant truncate on table "public"."results" to "authenticated";

grant update on table "public"."results" to "authenticated";

grant delete on table "public"."results" to "service_role";

grant insert on table "public"."results" to "service_role";

grant references on table "public"."results" to "service_role";

grant select on table "public"."results" to "service_role";

grant trigger on table "public"."results" to "service_role";

grant truncate on table "public"."results" to "service_role";

grant update on table "public"."results" to "service_role";


