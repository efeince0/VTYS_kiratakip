PGDMP         )                |         
   VTYS_proje    14.15    14.15 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394 
   VTYS_proje    DATABASE     p   CREATE DATABASE "VTYS_proje" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
    DROP DATABASE "VTYS_proje";
                postgres    false                        2615    16395    sema1    SCHEMA        CREATE SCHEMA sema1;
    DROP SCHEMA sema1;
                postgres    false            �            1255    16656 "   birlestir_isim_soyisim(text, text)    FUNCTION     �   CREATE FUNCTION public.birlestir_isim_soyisim(isim text, soyisim text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN CONCAT(isim, ' ', soyisim);
END;
$$;
 F   DROP FUNCTION public.birlestir_isim_soyisim(isim text, soyisim text);
       public          postgres    false            �            1255    16655 (   birlestir_ucret_para_birimi(money, text)    FUNCTION     �   CREATE FUNCTION public.birlestir_ucret_para_birimi(ucret money, birim text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN CONCAT(ucret::NUMERIC::TEXT, ' ', birim);
END;
$$;
 K   DROP FUNCTION public.birlestir_ucret_para_birimi(ucret money, birim text);
       public          postgres    false            �            1255    16657    kalan_ay_hesapla(date)    FUNCTION     
  CREATE FUNCTION public.kalan_ay_hesapla(bitis_tarihi date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (DATE_PART('year', AGE(bitis_tarihi, CURRENT_DATE)) * 12
            + DATE_PART('month', AGE(bitis_tarihi, CURRENT_DATE)))::INTEGER;
END;
$$;
 :   DROP FUNCTION public.kalan_ay_hesapla(bitis_tarihi date);
       public          postgres    false                       1255    16698    guncelle_toplam_arsa()    FUNCTION     5  CREATE FUNCTION sema1.guncelle_toplam_arsa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- INSERT işlemi sırasında
    IF (TG_OP = 'INSERT') THEN
        IF (NEW."mulkTipiNo" = 3) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_arsa = toplam_arsa + 1;
        END IF;
    END IF;

    -- DELETE işlemi sırasında
    IF (TG_OP = 'DELETE') THEN
        IF (OLD."mulkTipiNo" = 3) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_arsa = toplam_arsa - 1;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION sema1.guncelle_toplam_arsa();
       sema1          postgres    false    5                       1255    16696    guncelle_toplam_isyeri()    FUNCTION     ?  CREATE FUNCTION sema1.guncelle_toplam_isyeri() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- INSERT işlemi sırasında
    IF (TG_OP = 'INSERT') THEN
        IF (NEW."mulkTipiNo" = 2) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_isyeri = toplam_isyeri + 1;
        END IF;
    END IF;

    -- DELETE işlemi sırasında
    IF (TG_OP = 'DELETE') THEN
        IF (OLD."mulkTipiNo" = 2) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_isyeri = toplam_isyeri - 1;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
 .   DROP FUNCTION sema1.guncelle_toplam_isyeri();
       sema1          postgres    false    5                       1255    16694    guncelle_toplam_konut()    FUNCTION     :  CREATE FUNCTION sema1.guncelle_toplam_konut() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- INSERT işlemi sırasında
    IF (TG_OP = 'INSERT') THEN
        IF (NEW."mulkTipiNo" = 1) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_konut = toplam_konut + 1;
        END IF;
    END IF;

    -- DELETE işlemi sırasında
    IF (TG_OP = 'DELETE') THEN
        IF (OLD."mulkTipiNo" = 1) THEN
            UPDATE "sema1"."Mulk_Toplam"
            SET toplam_konut = toplam_konut - 1;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
 -   DROP FUNCTION sema1.guncelle_toplam_konut();
       sema1          postgres    false    5            �            1255    16672    log_kira_guncelleme()    FUNCTION     �  CREATE FUNCTION sema1.log_kira_guncelleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "sema1"."Kira_Log" (
        kiraNo,
        eski_baslangicTarihi,
        yeni_baslangicTarihi,
        eski_bitisTarihi,
        yeni_bitisTarihi,
        eski_ucret,
        yeni_ucret,
        eski_paraBirimiNo,
        yeni_paraBirimiNo,
        guncelleme_tarihi
    )
    VALUES (
        OLD."kiraNo",
        OLD."baslangicTarihi", NEW."baslangicTarihi",
        OLD."bitisTarihi", NEW."bitisTarihi",
        OLD."ucret", NEW."ucret",
        OLD."paraBirimiNo", NEW."paraBirimiNo",
        NOW()
    );

    RETURN NEW;
END;
$$;
 +   DROP FUNCTION sema1.log_kira_guncelleme();
       sema1          postgres    false    5            �            1255    16682    log_kiraci_guncelleme()    FUNCTION     �  CREATE FUNCTION sema1.log_kiraci_guncelleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "sema1"."Kiracilar_Log" (
        tcKimlikNo,
        eski_isim, yeni_isim,
        eski_soyisim, yeni_soyisim,
        eski_telefonNo, yeni_telefonNo,
        eski_dogumTarihi, yeni_dogumTarihi,
        eski_meslekNo, yeni_meslekNo,
        eski_medeniHaliNo, yeni_medeniHaliNo,
        guncelleme_tarihi
    )
    VALUES (
        OLD."tcKimlikNo",
        OLD."isim", NEW."isim",
        OLD."soyisim", NEW."soyisim",
        OLD."telefonNo", NEW."telefonNo",
        OLD."dogumTarihi", NEW."dogumTarihi",
        OLD."meslekNo", NEW."meslekNo",
        OLD."medeniHaliNo", NEW."medeniHaliNo",
        NOW()
    );

    RETURN NEW;
END;
$$;
 -   DROP FUNCTION sema1.log_kiraci_guncelleme();
       sema1          postgres    false    5            �            1259    16593    Arsalar    TABLE     X   CREATE TABLE sema1."Arsalar" (
    "mulkNo" integer,
    "parselNo" integer NOT NULL
);
    DROP TABLE sema1."Arsalar";
       sema1         heap    postgres    false    5            �            1259    16551    Evtipi    TABLE     e   CREATE TABLE sema1."Evtipi" (
    "tipNo" integer NOT NULL,
    "odaSayisi" character varying(20)
);
    DROP TABLE sema1."Evtipi";
       sema1         heap    postgres    false    5            �            1259    16550    Evtipi_tipNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Evtipi_tipNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE sema1."Evtipi_tipNo_seq";
       sema1          postgres    false    5    233            �           0    0    Evtipi_tipNo_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE sema1."Evtipi_tipNo_seq" OWNED BY sema1."Evtipi"."tipNo";
          sema1          postgres    false    232            �            1259    16631 	   Faturalar    TABLE     �   CREATE TABLE sema1."Faturalar" (
    "faturaNo" integer NOT NULL,
    "kiraNo" integer,
    tarih date NOT NULL,
    miktar money,
    "paraBirimiNo" integer,
    "odemeDurumu" boolean NOT NULL
);
    DROP TABLE sema1."Faturalar";
       sema1         heap    postgres    false    5            �            1259    16630    Faturalar_faturaNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Faturalar_faturaNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sema1."Faturalar_faturaNo_seq";
       sema1          postgres    false    242    5            �           0    0    Faturalar_faturaNo_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE sema1."Faturalar_faturaNo_seq" OWNED BY sema1."Faturalar"."faturaNo";
          sema1          postgres    false    241            �            1259    16416    Ilceler    TABLE     �   CREATE TABLE sema1."Ilceler" (
    "ilceNo" integer NOT NULL,
    "ilceIsmi" character varying(50) NOT NULL,
    "sehirNo" integer
);
    DROP TABLE sema1."Ilceler";
       sema1         heap    postgres    false    5            �            1259    16415    Ilceler_ilceNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Ilceler_ilceNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE sema1."Ilceler_ilceNo_seq";
       sema1          postgres    false    215    5            �           0    0    Ilceler_ilceNo_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE sema1."Ilceler_ilceNo_seq" OWNED BY sema1."Ilceler"."ilceNo";
          sema1          postgres    false    214            �            1259    16578 	   IsYerleri    TABLE     �  CREATE TABLE sema1."IsYerleri" (
    "mulkNo" integer,
    "binaNo" integer NOT NULL,
    "daireNo" integer NOT NULL,
    "binaYasi" integer,
    "isitmaNo" integer,
    "katSayisi" integer,
    asansorlu boolean,
    otopark boolean,
    depo boolean,
    CONSTRAINT "IsYerleri_binaYasi_check" CHECK (("binaYasi" >= 0)),
    CONSTRAINT "IsYerleri_katSayisi_check" CHECK (("katSayisi" >= 0))
);
    DROP TABLE sema1."IsYerleri";
       sema1         heap    postgres    false    5            �            1259    16544 	   IsitmaTur    TABLE     k   CREATE TABLE sema1."IsitmaTur" (
    "isitmaNo" integer NOT NULL,
    "isitmaAdi" character varying(25)
);
    DROP TABLE sema1."IsitmaTur";
       sema1         heap    postgres    false    5            �            1259    16543    IsitmaTur_isitmaNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."IsitmaTur_isitmaNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sema1."IsitmaTur_isitmaNo_seq";
       sema1          postgres    false    231    5            �           0    0    IsitmaTur_isitmaNo_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE sema1."IsitmaTur_isitmaNo_seq" OWNED BY sema1."IsitmaTur"."isitmaNo";
          sema1          postgres    false    230            �            1259    16609    Kira    TABLE     �   CREATE TABLE sema1."Kira" (
    "kiraNo" integer NOT NULL,
    "mulkNo" integer,
    "kiraciNo" integer,
    "baslangicTarihi" date NOT NULL,
    "bitisTarihi" date,
    ucret money,
    "paraBirimiNo" integer
);
    DROP TABLE sema1."Kira";
       sema1         heap    postgres    false    5            �            1259    16663    Kira_Log    TABLE       CREATE TABLE sema1."Kira_Log" (
    log_id integer NOT NULL,
    kirano integer NOT NULL,
    eski_baslangictarihi date,
    yeni_baslangictarihi date,
    eski_bitistarihi date,
    yeni_bitistarihi date,
    eski_ucret numeric,
    yeni_ucret numeric,
    eski_parabirimino integer,
    yeni_parabirimino integer,
    guncelleme_tarihi timestamp without time zone DEFAULT now()
);
    DROP TABLE sema1."Kira_Log";
       sema1         heap    postgres    false    5            �            1259    16662    Kira_Log_log_id_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Kira_Log_log_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE sema1."Kira_Log_log_id_seq";
       sema1          postgres    false    5    244            �           0    0    Kira_Log_log_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE sema1."Kira_Log_log_id_seq" OWNED BY sema1."Kira_Log".log_id;
          sema1          postgres    false    243            �            1259    16608    Kira_kiraNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Kira_kiraNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE sema1."Kira_kiraNo_seq";
       sema1          postgres    false    5    240            �           0    0    Kira_kiraNo_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE sema1."Kira_kiraNo_seq" OWNED BY sema1."Kira"."kiraNo";
          sema1          postgres    false    239            �            1259    16485 	   Kiracilar    TABLE     A  CREATE TABLE sema1."Kiracilar" (
    "kiraciNo" integer NOT NULL,
    "tcKimlikNo" character(11) NOT NULL,
    isim character varying(50) NOT NULL,
    soyisim character varying(50) NOT NULL,
    "telefonNo" character(10) NOT NULL,
    "dogumTarihi" date,
    "meslekNo" smallint,
    "medeniHaliNo" smallint NOT NULL
);
    DROP TABLE sema1."Kiracilar";
       sema1         heap    postgres    false    5            �            1259    16675    Kiracilar_Log    TABLE     P  CREATE TABLE sema1."Kiracilar_Log" (
    log_id integer NOT NULL,
    tckimlikno character varying(11) NOT NULL,
    eski_isim character varying(100),
    yeni_isim character varying(100),
    eski_soyisim character varying(100),
    yeni_soyisim character varying(100),
    eski_telefonno character varying(20),
    yeni_telefonno character varying(20),
    eski_dogumtarihi date,
    yeni_dogumtarihi date,
    eski_meslekno integer,
    yeni_meslekno integer,
    eski_medenihalino integer,
    yeni_medenihalino integer,
    guncelleme_tarihi timestamp without time zone DEFAULT now()
);
 "   DROP TABLE sema1."Kiracilar_Log";
       sema1         heap    postgres    false    5            �            1259    16674    Kiracilar_Log_log_id_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Kiracilar_Log_log_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE sema1."Kiracilar_Log_log_id_seq";
       sema1          postgres    false    246    5            �           0    0    Kiracilar_Log_log_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE sema1."Kiracilar_Log_log_id_seq" OWNED BY sema1."Kiracilar_Log".log_id;
          sema1          postgres    false    245            �            1259    16484    Kiracilar_kiraciNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Kiracilar_kiraciNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sema1."Kiracilar_kiraciNo_seq";
       sema1          postgres    false    225    5            �           0    0    Kiracilar_kiraciNo_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE sema1."Kiracilar_kiraciNo_seq" OWNED BY sema1."Kiracilar"."kiraciNo";
          sema1          postgres    false    224            �            1259    16557    Konutlar    TABLE     W  CREATE TABLE sema1."Konutlar" (
    "mulkNo" integer,
    "apartmanNo" integer NOT NULL,
    "daireNo" integer NOT NULL,
    "tipNo" integer,
    "binaYasi" integer,
    "isitmaNo" integer,
    "katSayisi" integer,
    "banyoSayisi" integer,
    mobilyali boolean,
    asansorlu boolean,
    otopark boolean,
    balkon boolean,
    site boolean,
    "siteAdi" character varying(100),
    CONSTRAINT "Konutlar_banyoSayisi_check" CHECK (("banyoSayisi" >= 0)),
    CONSTRAINT "Konutlar_binaYasi_check" CHECK (("binaYasi" >= 0)),
    CONSTRAINT "Konutlar_katSayisi_check" CHECK (("katSayisi" >= 0))
);
    DROP TABLE sema1."Konutlar";
       sema1         heap    postgres    false    5            �            1259    16433 
   Mahalleler    TABLE     �   CREATE TABLE sema1."Mahalleler" (
    "mahalleNo" integer NOT NULL,
    "mahalleIsmi" character varying(50) NOT NULL,
    "ilceNo" integer
);
    DROP TABLE sema1."Mahalleler";
       sema1         heap    postgres    false    5            �            1259    16432    Mahalleler_mahalleNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Mahalleler_mahalleNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE sema1."Mahalleler_mahalleNo_seq";
       sema1          postgres    false    5    217            �           0    0    Mahalleler_mahalleNo_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE sema1."Mahalleler_mahalleNo_seq" OWNED BY sema1."Mahalleler"."mahalleNo";
          sema1          postgres    false    216            �            1259    16476    MedeniHaller    TABLE     |   CREATE TABLE sema1."MedeniHaller" (
    "medeniHaliNo" integer NOT NULL,
    "medeniHali" character varying(20) NOT NULL
);
 !   DROP TABLE sema1."MedeniHaller";
       sema1         heap    postgres    false    5            �            1259    16475    MedeniHaller_medeniHaliNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."MedeniHaller_medeniHaliNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE sema1."MedeniHaller_medeniHaliNo_seq";
       sema1          postgres    false    5    223            �           0    0    MedeniHaller_medeniHaliNo_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE sema1."MedeniHaller_medeniHaliNo_seq" OWNED BY sema1."MedeniHaller"."medeniHaliNo";
          sema1          postgres    false    222            �            1259    16467 	   Meslekler    TABLE     u   CREATE TABLE sema1."Meslekler" (
    "meslekNo" integer NOT NULL,
    "meslekAdi" character varying(100) NOT NULL
);
    DROP TABLE sema1."Meslekler";
       sema1         heap    postgres    false    5            �            1259    16466    Meslekler_meslekNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Meslekler_meslekNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sema1."Meslekler_meslekNo_seq";
       sema1          postgres    false    221    5            �           0    0    Meslekler_meslekNo_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE sema1."Meslekler_meslekNo_seq" OWNED BY sema1."Meslekler"."meslekNo";
          sema1          postgres    false    220            �            1259    16504    MulkTipleri    TABLE     z   CREATE TABLE sema1."MulkTipleri" (
    "mulkTipiNo" integer NOT NULL,
    "mulkTipiAdi" character varying(50) NOT NULL
);
     DROP TABLE sema1."MulkTipleri";
       sema1         heap    postgres    false    5            �            1259    16503    MulkTipleri_mulkTipiNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."MulkTipleri_mulkTipiNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE sema1."MulkTipleri_mulkTipiNo_seq";
       sema1          postgres    false    227    5            �           0    0    MulkTipleri_mulkTipiNo_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE sema1."MulkTipleri_mulkTipiNo_seq" OWNED BY sema1."MulkTipleri"."mulkTipiNo";
          sema1          postgres    false    226            �            1259    16685    Mulk_Toplam    TABLE     �   CREATE TABLE sema1."Mulk_Toplam" (
    id integer NOT NULL,
    toplam_konut integer DEFAULT 0,
    toplam_isyeri integer DEFAULT 0,
    toplam_arsa integer DEFAULT 0
);
     DROP TABLE sema1."Mulk_Toplam";
       sema1         heap    postgres    false    5            �            1259    16684    Mulk_Toplam_id_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Mulk_Toplam_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE sema1."Mulk_Toplam_id_seq";
       sema1          postgres    false    5    248            �           0    0    Mulk_Toplam_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE sema1."Mulk_Toplam_id_seq" OWNED BY sema1."Mulk_Toplam".id;
          sema1          postgres    false    247            �            1259    16511    Mulkler    TABLE     �  CREATE TABLE sema1."Mulkler" (
    "mulkNo" integer NOT NULL,
    "mulkAdi" character varying(100) NOT NULL,
    "metreKare" integer,
    "mulkTipiNo" smallint,
    "sokakNo" integer,
    "mahalleNo" integer,
    "ilceNo" integer,
    "sehirNo" integer,
    "ulkeNo" smallint,
    "adresMetni" character varying(255) NOT NULL,
    "postaKodu" character varying(10),
    CONSTRAINT "Mulkler_metreKare_check" CHECK (("metreKare" > 0))
);
    DROP TABLE sema1."Mulkler";
       sema1         heap    postgres    false    5            �            1259    16510    Mulkler_mulkNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Mulkler_mulkNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE sema1."Mulkler_mulkNo_seq";
       sema1          postgres    false    5    229            �           0    0    Mulkler_mulkNo_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE sema1."Mulkler_mulkNo_seq" OWNED BY sema1."Mulkler"."mulkNo";
          sema1          postgres    false    228            �            1259    16602 
   ParaBirimi    TABLE     �   CREATE TABLE sema1."ParaBirimi" (
    "paraBirimiNo" integer NOT NULL,
    "birimAdi" character varying(25) NOT NULL,
    "birimKisaltma" character varying(10) NOT NULL
);
    DROP TABLE sema1."ParaBirimi";
       sema1         heap    postgres    false    5            �            1259    16601    ParaBirimi_paraBirimiNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."ParaBirimi_paraBirimiNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE sema1."ParaBirimi_paraBirimiNo_seq";
       sema1          postgres    false    5    238            �           0    0    ParaBirimi_paraBirimiNo_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE sema1."ParaBirimi_paraBirimiNo_seq" OWNED BY sema1."ParaBirimi"."paraBirimiNo";
          sema1          postgres    false    237            �            1259    16404    Sehirler    TABLE     �   CREATE TABLE sema1."Sehirler" (
    "sehirNo" integer NOT NULL,
    "sehirIsmi" character varying(50) NOT NULL,
    "ulkeNo" smallint
);
    DROP TABLE sema1."Sehirler";
       sema1         heap    postgres    false    5            �            1259    16403    Sehirler_sehirNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Sehirler_sehirNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE sema1."Sehirler_sehirNo_seq";
       sema1          postgres    false    213    5            �           0    0    Sehirler_sehirNo_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE sema1."Sehirler_sehirNo_seq" OWNED BY sema1."Sehirler"."sehirNo";
          sema1          postgres    false    212            �            1259    16450    Sokaklar    TABLE     �   CREATE TABLE sema1."Sokaklar" (
    "sokakNo" integer NOT NULL,
    "sokakIsmi" character varying(50) NOT NULL,
    "mahalleNo" integer
);
    DROP TABLE sema1."Sokaklar";
       sema1         heap    postgres    false    5            �            1259    16449    Sokaklar_sokakNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Sokaklar_sokakNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE sema1."Sokaklar_sokakNo_seq";
       sema1          postgres    false    219    5            �           0    0    Sokaklar_sokakNo_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE sema1."Sokaklar_sokakNo_seq" OWNED BY sema1."Sokaklar"."sokakNo";
          sema1          postgres    false    218            �            1259    16397    Ulkeler    TABLE     o   CREATE TABLE sema1."Ulkeler" (
    "ulkeNo" integer NOT NULL,
    "ulkeIsmi" character varying(50) NOT NULL
);
    DROP TABLE sema1."Ulkeler";
       sema1         heap    postgres    false    5            �            1259    16396    Ulkeler_ulkeNo_seq    SEQUENCE     �   CREATE SEQUENCE sema1."Ulkeler_ulkeNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE sema1."Ulkeler_ulkeNo_seq";
       sema1          postgres    false    5    211            �           0    0    Ulkeler_ulkeNo_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE sema1."Ulkeler_ulkeNo_seq" OWNED BY sema1."Ulkeler"."ulkeNo";
          sema1          postgres    false    210            �           2604    16554    Evtipi tipNo    DEFAULT     p   ALTER TABLE ONLY sema1."Evtipi" ALTER COLUMN "tipNo" SET DEFAULT nextval('sema1."Evtipi_tipNo_seq"'::regclass);
 >   ALTER TABLE sema1."Evtipi" ALTER COLUMN "tipNo" DROP DEFAULT;
       sema1          postgres    false    233    232    233            �           2604    16634    Faturalar faturaNo    DEFAULT     |   ALTER TABLE ONLY sema1."Faturalar" ALTER COLUMN "faturaNo" SET DEFAULT nextval('sema1."Faturalar_faturaNo_seq"'::regclass);
 D   ALTER TABLE sema1."Faturalar" ALTER COLUMN "faturaNo" DROP DEFAULT;
       sema1          postgres    false    242    241    242            �           2604    16419    Ilceler ilceNo    DEFAULT     t   ALTER TABLE ONLY sema1."Ilceler" ALTER COLUMN "ilceNo" SET DEFAULT nextval('sema1."Ilceler_ilceNo_seq"'::regclass);
 @   ALTER TABLE sema1."Ilceler" ALTER COLUMN "ilceNo" DROP DEFAULT;
       sema1          postgres    false    214    215    215            �           2604    16547    IsitmaTur isitmaNo    DEFAULT     |   ALTER TABLE ONLY sema1."IsitmaTur" ALTER COLUMN "isitmaNo" SET DEFAULT nextval('sema1."IsitmaTur_isitmaNo_seq"'::regclass);
 D   ALTER TABLE sema1."IsitmaTur" ALTER COLUMN "isitmaNo" DROP DEFAULT;
       sema1          postgres    false    231    230    231            �           2604    16612    Kira kiraNo    DEFAULT     n   ALTER TABLE ONLY sema1."Kira" ALTER COLUMN "kiraNo" SET DEFAULT nextval('sema1."Kira_kiraNo_seq"'::regclass);
 =   ALTER TABLE sema1."Kira" ALTER COLUMN "kiraNo" DROP DEFAULT;
       sema1          postgres    false    240    239    240            �           2604    16666    Kira_Log log_id    DEFAULT     t   ALTER TABLE ONLY sema1."Kira_Log" ALTER COLUMN log_id SET DEFAULT nextval('sema1."Kira_Log_log_id_seq"'::regclass);
 ?   ALTER TABLE sema1."Kira_Log" ALTER COLUMN log_id DROP DEFAULT;
       sema1          postgres    false    244    243    244            �           2604    16488    Kiracilar kiraciNo    DEFAULT     |   ALTER TABLE ONLY sema1."Kiracilar" ALTER COLUMN "kiraciNo" SET DEFAULT nextval('sema1."Kiracilar_kiraciNo_seq"'::regclass);
 D   ALTER TABLE sema1."Kiracilar" ALTER COLUMN "kiraciNo" DROP DEFAULT;
       sema1          postgres    false    225    224    225            �           2604    16678    Kiracilar_Log log_id    DEFAULT     ~   ALTER TABLE ONLY sema1."Kiracilar_Log" ALTER COLUMN log_id SET DEFAULT nextval('sema1."Kiracilar_Log_log_id_seq"'::regclass);
 D   ALTER TABLE sema1."Kiracilar_Log" ALTER COLUMN log_id DROP DEFAULT;
       sema1          postgres    false    246    245    246            �           2604    16436    Mahalleler mahalleNo    DEFAULT     �   ALTER TABLE ONLY sema1."Mahalleler" ALTER COLUMN "mahalleNo" SET DEFAULT nextval('sema1."Mahalleler_mahalleNo_seq"'::regclass);
 F   ALTER TABLE sema1."Mahalleler" ALTER COLUMN "mahalleNo" DROP DEFAULT;
       sema1          postgres    false    216    217    217            �           2604    16479    MedeniHaller medeniHaliNo    DEFAULT     �   ALTER TABLE ONLY sema1."MedeniHaller" ALTER COLUMN "medeniHaliNo" SET DEFAULT nextval('sema1."MedeniHaller_medeniHaliNo_seq"'::regclass);
 K   ALTER TABLE sema1."MedeniHaller" ALTER COLUMN "medeniHaliNo" DROP DEFAULT;
       sema1          postgres    false    222    223    223            �           2604    16470    Meslekler meslekNo    DEFAULT     |   ALTER TABLE ONLY sema1."Meslekler" ALTER COLUMN "meslekNo" SET DEFAULT nextval('sema1."Meslekler_meslekNo_seq"'::regclass);
 D   ALTER TABLE sema1."Meslekler" ALTER COLUMN "meslekNo" DROP DEFAULT;
       sema1          postgres    false    220    221    221            �           2604    16507    MulkTipleri mulkTipiNo    DEFAULT     �   ALTER TABLE ONLY sema1."MulkTipleri" ALTER COLUMN "mulkTipiNo" SET DEFAULT nextval('sema1."MulkTipleri_mulkTipiNo_seq"'::regclass);
 H   ALTER TABLE sema1."MulkTipleri" ALTER COLUMN "mulkTipiNo" DROP DEFAULT;
       sema1          postgres    false    226    227    227            �           2604    16688    Mulk_Toplam id    DEFAULT     r   ALTER TABLE ONLY sema1."Mulk_Toplam" ALTER COLUMN id SET DEFAULT nextval('sema1."Mulk_Toplam_id_seq"'::regclass);
 >   ALTER TABLE sema1."Mulk_Toplam" ALTER COLUMN id DROP DEFAULT;
       sema1          postgres    false    247    248    248            �           2604    16514    Mulkler mulkNo    DEFAULT     t   ALTER TABLE ONLY sema1."Mulkler" ALTER COLUMN "mulkNo" SET DEFAULT nextval('sema1."Mulkler_mulkNo_seq"'::regclass);
 @   ALTER TABLE sema1."Mulkler" ALTER COLUMN "mulkNo" DROP DEFAULT;
       sema1          postgres    false    229    228    229            �           2604    16605    ParaBirimi paraBirimiNo    DEFAULT     �   ALTER TABLE ONLY sema1."ParaBirimi" ALTER COLUMN "paraBirimiNo" SET DEFAULT nextval('sema1."ParaBirimi_paraBirimiNo_seq"'::regclass);
 I   ALTER TABLE sema1."ParaBirimi" ALTER COLUMN "paraBirimiNo" DROP DEFAULT;
       sema1          postgres    false    237    238    238            �           2604    16407    Sehirler sehirNo    DEFAULT     x   ALTER TABLE ONLY sema1."Sehirler" ALTER COLUMN "sehirNo" SET DEFAULT nextval('sema1."Sehirler_sehirNo_seq"'::regclass);
 B   ALTER TABLE sema1."Sehirler" ALTER COLUMN "sehirNo" DROP DEFAULT;
       sema1          postgres    false    212    213    213            �           2604    16453    Sokaklar sokakNo    DEFAULT     x   ALTER TABLE ONLY sema1."Sokaklar" ALTER COLUMN "sokakNo" SET DEFAULT nextval('sema1."Sokaklar_sokakNo_seq"'::regclass);
 B   ALTER TABLE sema1."Sokaklar" ALTER COLUMN "sokakNo" DROP DEFAULT;
       sema1          postgres    false    219    218    219            �           2604    16400    Ulkeler ulkeNo    DEFAULT     t   ALTER TABLE ONLY sema1."Ulkeler" ALTER COLUMN "ulkeNo" SET DEFAULT nextval('sema1."Ulkeler_ulkeNo_seq"'::regclass);
 @   ALTER TABLE sema1."Ulkeler" ALTER COLUMN "ulkeNo" DROP DEFAULT;
       sema1          postgres    false    211    210    211            �          0    16593    Arsalar 
   TABLE DATA           8   COPY sema1."Arsalar" ("mulkNo", "parselNo") FROM stdin;
    sema1          postgres    false    236   T�       �          0    16551    Evtipi 
   TABLE DATA           7   COPY sema1."Evtipi" ("tipNo", "odaSayisi") FROM stdin;
    sema1          postgres    false    233   w�       �          0    16631 	   Faturalar 
   TABLE DATA           h   COPY sema1."Faturalar" ("faturaNo", "kiraNo", tarih, miktar, "paraBirimiNo", "odemeDurumu") FROM stdin;
    sema1          postgres    false    242   ��       �          0    16416    Ilceler 
   TABLE DATA           C   COPY sema1."Ilceler" ("ilceNo", "ilceIsmi", "sehirNo") FROM stdin;
    sema1          postgres    false    215   ��       �          0    16578 	   IsYerleri 
   TABLE DATA           �   COPY sema1."IsYerleri" ("mulkNo", "binaNo", "daireNo", "binaYasi", "isitmaNo", "katSayisi", asansorlu, otopark, depo) FROM stdin;
    sema1          postgres    false    235   ��       �          0    16544 	   IsitmaTur 
   TABLE DATA           =   COPY sema1."IsitmaTur" ("isitmaNo", "isitmaAdi") FROM stdin;
    sema1          postgres    false    231   �       �          0    16609    Kira 
   TABLE DATA           x   COPY sema1."Kira" ("kiraNo", "mulkNo", "kiraciNo", "baslangicTarihi", "bitisTarihi", ucret, "paraBirimiNo") FROM stdin;
    sema1          postgres    false    240   ��       �          0    16663    Kira_Log 
   TABLE DATA           �   COPY sema1."Kira_Log" (log_id, kirano, eski_baslangictarihi, yeni_baslangictarihi, eski_bitistarihi, yeni_bitistarihi, eski_ucret, yeni_ucret, eski_parabirimino, yeni_parabirimino, guncelleme_tarihi) FROM stdin;
    sema1          postgres    false    244   ��       �          0    16485 	   Kiracilar 
   TABLE DATA           �   COPY sema1."Kiracilar" ("kiraciNo", "tcKimlikNo", isim, soyisim, "telefonNo", "dogumTarihi", "meslekNo", "medeniHaliNo") FROM stdin;
    sema1          postgres    false    225   9�       �          0    16675    Kiracilar_Log 
   TABLE DATA           	  COPY sema1."Kiracilar_Log" (log_id, tckimlikno, eski_isim, yeni_isim, eski_soyisim, yeni_soyisim, eski_telefonno, yeni_telefonno, eski_dogumtarihi, yeni_dogumtarihi, eski_meslekno, yeni_meslekno, eski_medenihalino, yeni_medenihalino, guncelleme_tarihi) FROM stdin;
    sema1          postgres    false    246   
�       �          0    16557    Konutlar 
   TABLE DATA           �   COPY sema1."Konutlar" ("mulkNo", "apartmanNo", "daireNo", "tipNo", "binaYasi", "isitmaNo", "katSayisi", "banyoSayisi", mobilyali, asansorlu, otopark, balkon, site, "siteAdi") FROM stdin;
    sema1          postgres    false    234   w�       �          0    16433 
   Mahalleler 
   TABLE DATA           K   COPY sema1."Mahalleler" ("mahalleNo", "mahalleIsmi", "ilceNo") FROM stdin;
    sema1          postgres    false    217   ��       �          0    16476    MedeniHaller 
   TABLE DATA           E   COPY sema1."MedeniHaller" ("medeniHaliNo", "medeniHali") FROM stdin;
    sema1          postgres    false    223   ��       �          0    16467 	   Meslekler 
   TABLE DATA           =   COPY sema1."Meslekler" ("meslekNo", "meslekAdi") FROM stdin;
    sema1          postgres    false    221   ��       �          0    16504    MulkTipleri 
   TABLE DATA           C   COPY sema1."MulkTipleri" ("mulkTipiNo", "mulkTipiAdi") FROM stdin;
    sema1          postgres    false    227   ��       �          0    16685    Mulk_Toplam 
   TABLE DATA           T   COPY sema1."Mulk_Toplam" (id, toplam_konut, toplam_isyeri, toplam_arsa) FROM stdin;
    sema1          postgres    false    248   �       �          0    16511    Mulkler 
   TABLE DATA           �   COPY sema1."Mulkler" ("mulkNo", "mulkAdi", "metreKare", "mulkTipiNo", "sokakNo", "mahalleNo", "ilceNo", "sehirNo", "ulkeNo", "adresMetni", "postaKodu") FROM stdin;
    sema1          postgres    false    229   *�       �          0    16602 
   ParaBirimi 
   TABLE DATA           R   COPY sema1."ParaBirimi" ("paraBirimiNo", "birimAdi", "birimKisaltma") FROM stdin;
    sema1          postgres    false    238   ��       �          0    16404    Sehirler 
   TABLE DATA           E   COPY sema1."Sehirler" ("sehirNo", "sehirIsmi", "ulkeNo") FROM stdin;
    sema1          postgres    false    213   ��       �          0    16450    Sokaklar 
   TABLE DATA           H   COPY sema1."Sokaklar" ("sokakNo", "sokakIsmi", "mahalleNo") FROM stdin;
    sema1          postgres    false    219   (�       �          0    16397    Ulkeler 
   TABLE DATA           8   COPY sema1."Ulkeler" ("ulkeNo", "ulkeIsmi") FROM stdin;
    sema1          postgres    false    211   _�       �           0    0    Evtipi_tipNo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('sema1."Evtipi_tipNo_seq"', 1, false);
          sema1          postgres    false    232            �           0    0    Faturalar_faturaNo_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sema1."Faturalar_faturaNo_seq"', 1, false);
          sema1          postgres    false    241            �           0    0    Ilceler_ilceNo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('sema1."Ilceler_ilceNo_seq"', 1, false);
          sema1          postgres    false    214            �           0    0    IsitmaTur_isitmaNo_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sema1."IsitmaTur_isitmaNo_seq"', 1, false);
          sema1          postgres    false    230            �           0    0    Kira_Log_log_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('sema1."Kira_Log_log_id_seq"', 1, true);
          sema1          postgres    false    243            �           0    0    Kira_kiraNo_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('sema1."Kira_kiraNo_seq"', 1, true);
          sema1          postgres    false    239            �           0    0    Kiracilar_Log_log_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('sema1."Kiracilar_Log_log_id_seq"', 1, true);
          sema1          postgres    false    245            �           0    0    Kiracilar_kiraciNo_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('sema1."Kiracilar_kiraciNo_seq"', 8, true);
          sema1          postgres    false    224            �           0    0    Mahalleler_mahalleNo_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('sema1."Mahalleler_mahalleNo_seq"', 1, false);
          sema1          postgres    false    216            �           0    0    MedeniHaller_medeniHaliNo_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('sema1."MedeniHaller_medeniHaliNo_seq"', 1, false);
          sema1          postgres    false    222            �           0    0    Meslekler_meslekNo_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sema1."Meslekler_meslekNo_seq"', 1, false);
          sema1          postgres    false    220                        0    0    MulkTipleri_mulkTipiNo_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('sema1."MulkTipleri_mulkTipiNo_seq"', 3, true);
          sema1          postgres    false    226                       0    0    Mulk_Toplam_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('sema1."Mulk_Toplam_id_seq"', 1, true);
          sema1          postgres    false    247                       0    0    Mulkler_mulkNo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('sema1."Mulkler_mulkNo_seq"', 13, true);
          sema1          postgres    false    228                       0    0    ParaBirimi_paraBirimiNo_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('sema1."ParaBirimi_paraBirimiNo_seq"', 1, false);
          sema1          postgres    false    237                       0    0    Sehirler_sehirNo_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('sema1."Sehirler_sehirNo_seq"', 1, false);
          sema1          postgres    false    212                       0    0    Sokaklar_sokakNo_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('sema1."Sokaklar_sokakNo_seq"', 1, false);
          sema1          postgres    false    218                       0    0    Ulkeler_ulkeNo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('sema1."Ulkeler_ulkeNo_seq"', 1, false);
          sema1          postgres    false    210                        2606    16556    Evtipi Evtipi_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY sema1."Evtipi"
    ADD CONSTRAINT "Evtipi_pkey" PRIMARY KEY ("tipNo");
 ?   ALTER TABLE ONLY sema1."Evtipi" DROP CONSTRAINT "Evtipi_pkey";
       sema1            postgres    false    233                       2606    16636    Faturalar Faturalar_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY sema1."Faturalar"
    ADD CONSTRAINT "Faturalar_pkey" PRIMARY KEY ("faturaNo");
 E   ALTER TABLE ONLY sema1."Faturalar" DROP CONSTRAINT "Faturalar_pkey";
       sema1            postgres    false    242            �           2606    16421    Ilceler Ilceler_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY sema1."Ilceler"
    ADD CONSTRAINT "Ilceler_pkey" PRIMARY KEY ("ilceNo");
 A   ALTER TABLE ONLY sema1."Ilceler" DROP CONSTRAINT "Ilceler_pkey";
       sema1            postgres    false    215            �           2606    16549    IsitmaTur IsitmaTur_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY sema1."IsitmaTur"
    ADD CONSTRAINT "IsitmaTur_pkey" PRIMARY KEY ("isitmaNo");
 E   ALTER TABLE ONLY sema1."IsitmaTur" DROP CONSTRAINT "IsitmaTur_pkey";
       sema1            postgres    false    231                       2606    16671    Kira_Log Kira_Log_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY sema1."Kira_Log"
    ADD CONSTRAINT "Kira_Log_pkey" PRIMARY KEY (log_id);
 C   ALTER TABLE ONLY sema1."Kira_Log" DROP CONSTRAINT "Kira_Log_pkey";
       sema1            postgres    false    244                       2606    16614    Kira Kira_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY sema1."Kira"
    ADD CONSTRAINT "Kira_pkey" PRIMARY KEY ("kiraNo");
 ;   ALTER TABLE ONLY sema1."Kira" DROP CONSTRAINT "Kira_pkey";
       sema1            postgres    false    240            
           2606    16681     Kiracilar_Log Kiracilar_Log_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY sema1."Kiracilar_Log"
    ADD CONSTRAINT "Kiracilar_Log_pkey" PRIMARY KEY (log_id);
 M   ALTER TABLE ONLY sema1."Kiracilar_Log" DROP CONSTRAINT "Kiracilar_Log_pkey";
       sema1            postgres    false    246            �           2606    16490    Kiracilar Kiracilar_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY sema1."Kiracilar"
    ADD CONSTRAINT "Kiracilar_pkey" PRIMARY KEY ("kiraciNo");
 E   ALTER TABLE ONLY sema1."Kiracilar" DROP CONSTRAINT "Kiracilar_pkey";
       sema1            postgres    false    225            �           2606    16492 "   Kiracilar Kiracilar_tcKimlikNo_key 
   CONSTRAINT     h   ALTER TABLE ONLY sema1."Kiracilar"
    ADD CONSTRAINT "Kiracilar_tcKimlikNo_key" UNIQUE ("tcKimlikNo");
 O   ALTER TABLE ONLY sema1."Kiracilar" DROP CONSTRAINT "Kiracilar_tcKimlikNo_key";
       sema1            postgres    false    225            �           2606    16438    Mahalleler Mahalleler_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY sema1."Mahalleler"
    ADD CONSTRAINT "Mahalleler_pkey" PRIMARY KEY ("mahalleNo");
 G   ALTER TABLE ONLY sema1."Mahalleler" DROP CONSTRAINT "Mahalleler_pkey";
       sema1            postgres    false    217            �           2606    16483 (   MedeniHaller MedeniHaller_medeniHali_key 
   CONSTRAINT     n   ALTER TABLE ONLY sema1."MedeniHaller"
    ADD CONSTRAINT "MedeniHaller_medeniHali_key" UNIQUE ("medeniHali");
 U   ALTER TABLE ONLY sema1."MedeniHaller" DROP CONSTRAINT "MedeniHaller_medeniHali_key";
       sema1            postgres    false    223            �           2606    16481    MedeniHaller MedeniHaller_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY sema1."MedeniHaller"
    ADD CONSTRAINT "MedeniHaller_pkey" PRIMARY KEY ("medeniHaliNo");
 K   ALTER TABLE ONLY sema1."MedeniHaller" DROP CONSTRAINT "MedeniHaller_pkey";
       sema1            postgres    false    223            �           2606    16474 !   Meslekler Meslekler_meslekAdi_key 
   CONSTRAINT     f   ALTER TABLE ONLY sema1."Meslekler"
    ADD CONSTRAINT "Meslekler_meslekAdi_key" UNIQUE ("meslekAdi");
 N   ALTER TABLE ONLY sema1."Meslekler" DROP CONSTRAINT "Meslekler_meslekAdi_key";
       sema1            postgres    false    221            �           2606    16472    Meslekler Meslekler_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY sema1."Meslekler"
    ADD CONSTRAINT "Meslekler_pkey" PRIMARY KEY ("meslekNo");
 E   ALTER TABLE ONLY sema1."Meslekler" DROP CONSTRAINT "Meslekler_pkey";
       sema1            postgres    false    221            �           2606    16509    MulkTipleri MulkTipleri_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY sema1."MulkTipleri"
    ADD CONSTRAINT "MulkTipleri_pkey" PRIMARY KEY ("mulkTipiNo");
 I   ALTER TABLE ONLY sema1."MulkTipleri" DROP CONSTRAINT "MulkTipleri_pkey";
       sema1            postgres    false    227                       2606    16693    Mulk_Toplam Mulk_Toplam_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY sema1."Mulk_Toplam"
    ADD CONSTRAINT "Mulk_Toplam_pkey" PRIMARY KEY (id);
 I   ALTER TABLE ONLY sema1."Mulk_Toplam" DROP CONSTRAINT "Mulk_Toplam_pkey";
       sema1            postgres    false    248            �           2606    16517    Mulkler Mulkler_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_pkey" PRIMARY KEY ("mulkNo");
 A   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_pkey";
       sema1            postgres    false    229                       2606    16607    ParaBirimi ParaBirimi_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY sema1."ParaBirimi"
    ADD CONSTRAINT "ParaBirimi_pkey" PRIMARY KEY ("paraBirimiNo");
 G   ALTER TABLE ONLY sema1."ParaBirimi" DROP CONSTRAINT "ParaBirimi_pkey";
       sema1            postgres    false    238            �           2606    16409    Sehirler Sehirler_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY sema1."Sehirler"
    ADD CONSTRAINT "Sehirler_pkey" PRIMARY KEY ("sehirNo");
 C   ALTER TABLE ONLY sema1."Sehirler" DROP CONSTRAINT "Sehirler_pkey";
       sema1            postgres    false    213            �           2606    16455    Sokaklar Sokaklar_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY sema1."Sokaklar"
    ADD CONSTRAINT "Sokaklar_pkey" PRIMARY KEY ("sokakNo");
 C   ALTER TABLE ONLY sema1."Sokaklar" DROP CONSTRAINT "Sokaklar_pkey";
       sema1            postgres    false    219            �           2606    16402    Ulkeler Ulkeler_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY sema1."Ulkeler"
    ADD CONSTRAINT "Ulkeler_pkey" PRIMARY KEY ("ulkeNo");
 A   ALTER TABLE ONLY sema1."Ulkeler" DROP CONSTRAINT "Ulkeler_pkey";
       sema1            postgres    false    211            *           2620    16673    Kira log_kira_update    TRIGGER     w   CREATE TRIGGER log_kira_update AFTER UPDATE ON sema1."Kira" FOR EACH ROW EXECUTE FUNCTION sema1.log_kira_guncelleme();
 .   DROP TRIGGER log_kira_update ON sema1."Kira";
       sema1          postgres    false    240    252            &           2620    16683    Kiracilar log_kiraci_update    TRIGGER     �   CREATE TRIGGER log_kiraci_update AFTER UPDATE ON sema1."Kiracilar" FOR EACH ROW EXECUTE FUNCTION sema1.log_kiraci_guncelleme();
 5   DROP TRIGGER log_kiraci_update ON sema1."Kiracilar";
       sema1          postgres    false    253    225            )           2620    16699    Mulkler toplam_arsa_trigger    TRIGGER     �   CREATE TRIGGER toplam_arsa_trigger AFTER INSERT OR DELETE ON sema1."Mulkler" FOR EACH ROW EXECUTE FUNCTION sema1.guncelle_toplam_arsa();
 5   DROP TRIGGER toplam_arsa_trigger ON sema1."Mulkler";
       sema1          postgres    false    229    267            (           2620    16697    Mulkler toplam_isyeri_trigger    TRIGGER     �   CREATE TRIGGER toplam_isyeri_trigger AFTER INSERT OR DELETE ON sema1."Mulkler" FOR EACH ROW EXECUTE FUNCTION sema1.guncelle_toplam_isyeri();
 7   DROP TRIGGER toplam_isyeri_trigger ON sema1."Mulkler";
       sema1          postgres    false    229    258            '           2620    16695    Mulkler toplam_konut_trigger    TRIGGER     �   CREATE TRIGGER toplam_konut_trigger AFTER INSERT OR DELETE ON sema1."Mulkler" FOR EACH ROW EXECUTE FUNCTION sema1.guncelle_toplam_konut();
 6   DROP TRIGGER toplam_konut_trigger ON sema1."Mulkler";
       sema1          postgres    false    257    229                        2606    16596    Arsalar Arsalar_Mulkler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Arsalar"
    ADD CONSTRAINT "Arsalar_Mulkler_FK" FOREIGN KEY ("mulkNo") REFERENCES sema1."Mulkler"("mulkNo");
 G   ALTER TABLE ONLY sema1."Arsalar" DROP CONSTRAINT "Arsalar_Mulkler_FK";
       sema1          postgres    false    236    229    3324            $           2606    16637    Faturalar Faturalar_Kira_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Faturalar"
    ADD CONSTRAINT "Faturalar_Kira_FK" FOREIGN KEY ("kiraNo") REFERENCES sema1."Kira"("kiraNo");
 H   ALTER TABLE ONLY sema1."Faturalar" DROP CONSTRAINT "Faturalar_Kira_FK";
       sema1          postgres    false    242    240    3332            %           2606    16642 !   Faturalar Faturalar_ParaBirimi_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Faturalar"
    ADD CONSTRAINT "Faturalar_ParaBirimi_FK" FOREIGN KEY ("paraBirimiNo") REFERENCES sema1."ParaBirimi"("paraBirimiNo");
 N   ALTER TABLE ONLY sema1."Faturalar" DROP CONSTRAINT "Faturalar_ParaBirimi_FK";
       sema1          postgres    false    242    238    3330                       2606    16427    Ilceler Ilceler_Sehirler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Ilceler"
    ADD CONSTRAINT "Ilceler_Sehirler_FK" FOREIGN KEY ("sehirNo") REFERENCES sema1."Sehirler"("sehirNo");
 H   ALTER TABLE ONLY sema1."Ilceler" DROP CONSTRAINT "Ilceler_Sehirler_FK";
       sema1          postgres    false    3302    213    215                       2606    16422    Ilceler Ilceler_sehirNo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Ilceler"
    ADD CONSTRAINT "Ilceler_sehirNo_fkey" FOREIGN KEY ("sehirNo") REFERENCES sema1."Sehirler"("sehirNo");
 I   ALTER TABLE ONLY sema1."Ilceler" DROP CONSTRAINT "Ilceler_sehirNo_fkey";
       sema1          postgres    false    3302    215    213                       2606    16583     IsYerleri IsYerleri_IsitmaTur_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."IsYerleri"
    ADD CONSTRAINT "IsYerleri_IsitmaTur_FK" FOREIGN KEY ("isitmaNo") REFERENCES sema1."IsitmaTur"("isitmaNo");
 M   ALTER TABLE ONLY sema1."IsYerleri" DROP CONSTRAINT "IsYerleri_IsitmaTur_FK";
       sema1          postgres    false    235    3326    231                       2606    16588    IsYerleri IsYerleri_Mulkler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."IsYerleri"
    ADD CONSTRAINT "IsYerleri_Mulkler_FK" FOREIGN KEY ("mulkNo") REFERENCES sema1."Mulkler"("mulkNo");
 K   ALTER TABLE ONLY sema1."IsYerleri" DROP CONSTRAINT "IsYerleri_Mulkler_FK";
       sema1          postgres    false    235    229    3324            "           2606    16620    Kira Kira_Kiracilar_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Kira"
    ADD CONSTRAINT "Kira_Kiracilar_FK" FOREIGN KEY ("kiraciNo") REFERENCES sema1."Kiracilar"("kiraciNo");
 C   ALTER TABLE ONLY sema1."Kira" DROP CONSTRAINT "Kira_Kiracilar_FK";
       sema1          postgres    false    3318    225    240            !           2606    16615    Kira Kira_Mulkler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Kira"
    ADD CONSTRAINT "Kira_Mulkler_FK" FOREIGN KEY ("mulkNo") REFERENCES sema1."Mulkler"("mulkNo");
 A   ALTER TABLE ONLY sema1."Kira" DROP CONSTRAINT "Kira_Mulkler_FK";
       sema1          postgres    false    229    240    3324            #           2606    16625    Kira Kira_ParaBirimi_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Kira"
    ADD CONSTRAINT "Kira_ParaBirimi_FK" FOREIGN KEY ("paraBirimiNo") REFERENCES sema1."ParaBirimi"("paraBirimiNo");
 D   ALTER TABLE ONLY sema1."Kira" DROP CONSTRAINT "Kira_ParaBirimi_FK";
       sema1          postgres    false    238    3330    240                       2606    16498 #   Kiracilar Kiracilar_MedeniHaller_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Kiracilar"
    ADD CONSTRAINT "Kiracilar_MedeniHaller_FK" FOREIGN KEY ("medeniHaliNo") REFERENCES sema1."MedeniHaller"("medeniHaliNo");
 P   ALTER TABLE ONLY sema1."Kiracilar" DROP CONSTRAINT "Kiracilar_MedeniHaller_FK";
       sema1          postgres    false    225    223    3316                       2606    16493     Kiracilar Kiracilar_Meslekler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Kiracilar"
    ADD CONSTRAINT "Kiracilar_Meslekler_FK" FOREIGN KEY ("meslekNo") REFERENCES sema1."Meslekler"("meslekNo");
 M   ALTER TABLE ONLY sema1."Kiracilar" DROP CONSTRAINT "Kiracilar_Meslekler_FK";
       sema1          postgres    false    221    225    3312                       2606    16568    Konutlar Konutlar_Evtipi_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Konutlar"
    ADD CONSTRAINT "Konutlar_Evtipi_FK" FOREIGN KEY ("tipNo") REFERENCES sema1."Evtipi"("tipNo");
 H   ALTER TABLE ONLY sema1."Konutlar" DROP CONSTRAINT "Konutlar_Evtipi_FK";
       sema1          postgres    false    234    3328    233                       2606    16563    Konutlar Konutlar_IsitmaTur_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Konutlar"
    ADD CONSTRAINT "Konutlar_IsitmaTur_FK" FOREIGN KEY ("isitmaNo") REFERENCES sema1."IsitmaTur"("isitmaNo");
 K   ALTER TABLE ONLY sema1."Konutlar" DROP CONSTRAINT "Konutlar_IsitmaTur_FK";
       sema1          postgres    false    231    3326    234                       2606    16573    Konutlar Konutlar_Mulkler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Konutlar"
    ADD CONSTRAINT "Konutlar_Mulkler_FK" FOREIGN KEY ("mulkNo") REFERENCES sema1."Mulkler"("mulkNo");
 I   ALTER TABLE ONLY sema1."Konutlar" DROP CONSTRAINT "Konutlar_Mulkler_FK";
       sema1          postgres    false    234    229    3324                       2606    16444     Mahalleler Mahalleler_Ilceler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mahalleler"
    ADD CONSTRAINT "Mahalleler_Ilceler_FK" FOREIGN KEY ("ilceNo") REFERENCES sema1."Ilceler"("ilceNo");
 M   ALTER TABLE ONLY sema1."Mahalleler" DROP CONSTRAINT "Mahalleler_Ilceler_FK";
       sema1          postgres    false    3304    217    215                       2606    16439 !   Mahalleler Mahalleler_ilceNo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mahalleler"
    ADD CONSTRAINT "Mahalleler_ilceNo_fkey" FOREIGN KEY ("ilceNo") REFERENCES sema1."Ilceler"("ilceNo");
 N   ALTER TABLE ONLY sema1."Mahalleler" DROP CONSTRAINT "Mahalleler_ilceNo_fkey";
       sema1          postgres    false    217    3304    215                       2606    16528    Mulkler Mulkler_Ilceler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_Ilceler_FK" FOREIGN KEY ("ilceNo") REFERENCES sema1."Ilceler"("ilceNo");
 G   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_Ilceler_FK";
       sema1          postgres    false    215    229    3304                       2606    16523    Mulkler Mulkler_Mahalleler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_Mahalleler_FK" FOREIGN KEY ("mahalleNo") REFERENCES sema1."Mahalleler"("mahalleNo");
 J   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_Mahalleler_FK";
       sema1          postgres    false    217    229    3306                       2606    16518    Mulkler Mulkler_MulkTipleri_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_MulkTipleri_FK" FOREIGN KEY ("mulkTipiNo") REFERENCES sema1."MulkTipleri"("mulkTipiNo");
 K   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_MulkTipleri_FK";
       sema1          postgres    false    227    3322    229                       2606    16533    Mulkler Mulkler_Sehirler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_Sehirler_FK" FOREIGN KEY ("sehirNo") REFERENCES sema1."Sehirler"("sehirNo");
 H   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_Sehirler_FK";
       sema1          postgres    false    213    3302    229                       2606    16538    Mulkler Mulkler_Ulkeler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Mulkler"
    ADD CONSTRAINT "Mulkler_Ulkeler_FK" FOREIGN KEY ("ulkeNo") REFERENCES sema1."Ulkeler"("ulkeNo");
 G   ALTER TABLE ONLY sema1."Mulkler" DROP CONSTRAINT "Mulkler_Ulkeler_FK";
       sema1          postgres    false    211    3300    229                       2606    16461    Sokaklar Sokaklar_Mahalleler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Sokaklar"
    ADD CONSTRAINT "Sokaklar_Mahalleler_FK" FOREIGN KEY ("mahalleNo") REFERENCES sema1."Mahalleler"("mahalleNo");
 L   ALTER TABLE ONLY sema1."Sokaklar" DROP CONSTRAINT "Sokaklar_Mahalleler_FK";
       sema1          postgres    false    3306    219    217                       2606    16456     Sokaklar Sokaklar_mahalleNo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Sokaklar"
    ADD CONSTRAINT "Sokaklar_mahalleNo_fkey" FOREIGN KEY ("mahalleNo") REFERENCES sema1."Mahalleler"("mahalleNo");
 M   ALTER TABLE ONLY sema1."Sokaklar" DROP CONSTRAINT "Sokaklar_mahalleNo_fkey";
       sema1          postgres    false    219    3306    217                       2606    16410    Sehirler Ulkeler_Sehirler_FK    FK CONSTRAINT     �   ALTER TABLE ONLY sema1."Sehirler"
    ADD CONSTRAINT "Ulkeler_Sehirler_FK" FOREIGN KEY ("ulkeNo") REFERENCES sema1."Ulkeler"("ulkeNo");
 I   ALTER TABLE ONLY sema1."Sehirler" DROP CONSTRAINT "Ulkeler_Sehirler_FK";
       sema1          postgres    false    213    3300    211            �      x�3�442����� 
l�      �   3   x�ʹ  ��n�t/P�ׁ�	V�L�,�l����Σ�yՓ�H~��Z      �      x������ � �      �   �   x�=�Mj�0��oS,��E�`Z
鲛��DH��b��Yv�M.`�^���}o����*�A���;���?)ǫ�F] �@�ǁ�*73�
{v�e2v�"�ۤ��<��e��%�|���D���p`T$$:5����K���S�g�$
<[vaՏ�
/������RVy�$��E[��1�Wg��̰;x����ģLA2F��f���st�c��$����u�N���)	[�      �   9   x���44�4F�Ɯ%�i�%\��F�� Q�`H���(k�Z q	r��qqq 8�	�      �   �   x�%Ȼ�0 ��n
O�>	�DET�"�8pB���*Ð�P���#^�
��W4�h9D2��ƙ�q��%n���(�C�!M��Z����fq��t�_BG�N�Fb�k~��{h4�:�i�XZFQ[�O��"~N1�      �   )   x�3�4�4�4202�54�5��3�,8U,�8͹b���� ���      �   D   x�]���0�ji�,`��`��,�����4A�h�z���:Z��iL �:��;��v���S���F��      �   �   x�M�=�1����)�@��ē�D�����]�3� ��{��{��&i���>�e��������=�}�Z�{��p�I�\*7�[���o�$�&fʩ ���3،�'����p����W�Y2I���>��:d���R��q7|�3FC��q�9����D����۟.#,�C#L�?n3�VS���d>�      �   ]   x�3�4D ��Ԝ�<���T$V��m�ť0���������� �	�&�f��f�LCsNCSN#402�54�52R04�21�2��35467����� 8�      �   ;   x�3�4�4�4�4�4bC�4�(tT(�,I-��2�44��U����4�?�=... �	�      �   �  x�u��n�0���S�	
Kr��خ�
d��a6�f!��R���>��{oq�kb�A��3E~$?2�7d�o�n���r�t~�F�e �]@���\���K������B5W*0qa����J�q
lY؛�1f�DF�3�G[j�w)ix7G���Ф�!�_T��Е%�8�e�J*Hk9R:�]9[PC/rd��bX���f+������f����a@�v�x
�����2X�?����^Ua���m<�F������d&"ࣙB8r���ն��_qL O�^OR�/4A�	��(���b�|C�g��\ھ�E��Q�V���&�HPpXȒ��.������f�KQ����9��No��t��E2��P�)|��HS5��Qd���X>$��(�0���<U��x��n{T��!0�9|&-�@G\c�vh��[q۩��7A���`^�������q��R�/c�3X�A��������$�      �      x�3�tJ�N,�2�t-������� 5��      �   �   x��=j�@��y�	^��4�8���0�yQ��"�
V�@t�� eT��W�V�WV�f>�f���9�F,%��
_9Z����i�4�]ž��x3v�	mp�ʈ�H�4�v8֖s��I
��8�H�+��*�&�0��]��1��]���H->u�g���q��|�3��J6�=�.�}9�f�[<���Me�g�ⴝ�=�Y;K��p��u�O�4�rGD�C�Wh      �   '   x�3����+-�2�<�����ԢL.cNǢ�D�=... �9	�      �      x�3�4�4�4����� ��      �   �   x���91E��� �d+��[P�Ѥ���%R,���wƂ��������l*�ps�7yf\b�:i>�f|�
q!�C���pE��k��p�=_o�ē�F�|~W�r&_���Hn{$6�<�
�b��z��?)��3G����~"�/�\G}      �   �   x�E�;
�@��z�{��(����\72�
z�b��]<�������j�*^�W3��'�t�u�FxON%�%)s�L�� 9R�Mx?܎-_��dĲc�l����S�)�d�a��hK?�%؁��I�^�C�&�-Y��.F���{�ōK5���y��*���k<�Nc\W���F      �     x�=SKn�@]Ӈ)$��K1��H4n��Ж$���d@�@oQ]��t��{������p�y$]H34��#4�{��S����)��Q7h��C:�v> ����[�x��X�9�Զ'͡H{���u`��|.�FsHׅ�.�.�xD����d����n���ˎQ ��f��7�̍`�M]�9�Xx1��r݄xm���t�.7z(5�t�v���6����x
6%�y�����6���u��!l�B_��(]y��Ѵ���͛N>&p?]��r�(i�_�r�)�H�=C��-w�<�=��ߦE��X)*ɬBآe�TD���ڰp*&�7��$�-�[�hs��w��ـ�¶>���#bd����ti�0��v!�e>Wq��Imƕ��#z��4�����c)�	a�x�O�5.<�y�X���g�:#�� 6^�T��A@�ZBx�ڶ#���!1��4A���6Cl���.��Cv�C�qBv�9,"�
����v�M�އ��yo� ~�R�!����*���y��l�{(�d�aBW��;�1rxd���\�m�#�	lo�\���Q�r,w�AR?��/�nY�(�W,��g,���E����b�J�{��QL����ח�j�V�9�      �   '  x�]�͎�F���S�	͗>��&h�m�ESؠn=��%C�x_�oQ{�/9�&�{����=�'J"��������w_��=��@;�4_lm�����~.n��B.<S�¯mU�b���Gu���>�f�׺��m'\�=�+�l}%E��㹦6�����BN�B�7{��(x��n�.~:C����Ml��pi��h�+�Q�\V;�_N�dpWӪq��(r�o����lD�����r�	����e'�U��8��j<?�Li�(o����?���
e
��Us��B]?��~zK���'̠`�h�A���f<�3�%�\˔���~DT�K7�W�]���PiN;�����rT)#zʃ��'�Ĭ��sC���aw�'��u�å�[7#_����)"j���v;�#�p�d{k�Bu��x��_*�)�D۹Mϼ�7�Ѩ�f7i�h�2^4�o��S�	����H�F�o���{����]u[�q@����O�9����ꖱ�;�x3�749��~��efEX���	�	��o7��Fy*�+���Vl�n&��l<��60����(���q��t�'������4_��Q���L�U�dq�<o\�R���D�<�cR��w͡�c�9V�c�.w�#��u�H f��y�p�N0O�F�Hp5�}�o����G�7�l���-�UTEK�5���*�Mn�,T��漲͊�8��qj>���|Ԫ��q�|ۛv�L�,���\��л�����~G���C���m0�K��׽
0�B�=���z���*s,�_�?�#���
�      �      x�3�9��(;�2�+F��� 1B�     