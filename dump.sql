|library%14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)%14.13 (Ubuntu 14.13-0ubuntu0.220ENCODINENCODINGSET client_encoding = 'UTF8';
00lse�
STDSTRINGS
STDSTRINGS(SET standard_conforming_strings = 'on';
00lse�
SEARCHPATH
SEARCHPATH8SELECT pg_catalog.set_config('search_path', '', false);
126216385librarDATABASE\CREATE DATABASE library WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
DROP DATABASE library;
postgresfalse�125916387clientsTABLE�CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(100),
    age character varying(3),
    city character varying(50)
);

ROP TABLE public.clients;
publicheapricardofalse�125916386clients_id_seSEQUENCE�CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
%DROP SEQUENCE public.clients_id_seq;
00clients_id_seqSEQUENCE OWNED BYAALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;
publicricardofalse209�125916428clients_productsTABLEjCREATE TABLE public.clients_products (
    client_id integer NOT NULL,
    product_id integer NOT NULL
);
$DROP TABLE public.clients_products;
publicheapricardofalse�125916401ordersTABLE�CREATE TABLE public.orders (
    id integer NOT NULL,
    customer_id integer,
    amount numeric(10,2),
    order_date date
);
�DROP TABLE public.orders;
orders_id_seSEQUENCE�CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
$DROP SEQUENCE public.orders_id_seq;
orders_id_seqSEQUENCE OWNED BY?ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
publicricardofalse211�12591641productsTABLE�CREATE TABLE public.products (
    id integer NOT NULL,
    product_name character varying(100),
    value numeric(10,2),
    quantity integer
);
DROP TABLE public.products;
publicheapricardofalse�125916416products_id_seSEQUENCE�CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
&DROP SEQUENCE public.products_id_seq;
00products_id_seqSEQUENCE OWNED BYCALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
260416390ardofalse213
clients idDEFAULThALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);
9ALTER TABLE public.clients ALTER COLUMN id DROP DEFAULT;
260416404ardofalorders idDEFAULTfALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
8ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
260416420ardofalse211212212
         products idDEFAULTjALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
:ALTER TABLE public.products ALTER COLUMN id DROP DEFAULT;
016387clientsfalse213214214�
TABLE DATA6COPY public.clients (id, name, age, city) FROM stdin;
016428clients_products!�
TABLE DATAACOPY public.clients_products (client_id, product_id) FROM stdin;
016401ordersofalse215�"�
TABLE DATAECOPY public.orders (id, customer_id, amount, order_date) FROM stdin;
01641productsfalse212#�
TABLE DATAECOPY public.products (id, product_name, value, quantity) FROM stdin;
00clients_id_seqse214�#�
                SEQUENCE SET=SELECT pg_catalog.setval('public.clients_id_seq', 16, true);
orders_id_seqfalse209�
             SEQUENCE SET<SELECT pg_catalog.setval('public.orders_id_seq', 10, true);
00products_id_seqe211�
                 SEQUENCE SET>SELECT pg_catalog.setval('public.products_id_seq', 10, true);
260616392clients clients_pkey
CONSTRAINTRALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);
>ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
60616432&clients_products clients_products_pkey
CONSTRAINTwALTER TABLE ONLY public.clients_products
    ADD CONSTRAINT clients_products_pkey PRIMARY KEY (client_id, product_id);
PALTER TABLE ONLY public.clients_products DROP CONSTRAINT clients_products_pkey;
260616406orders orders_pkey
CONSTRAINTPALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
<ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
260616422products products_pkey
CONSTRAINTTALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
@ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
FK CONSTRAINT�ALTER TABLE ONLY public.clients_productsfkey
    ADD CONSTRAINT clients_products_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;
ZALTER TABLE ONLY public.clients_products DROP CONSTRAINT clients_products_client_id_fkey;
FK CONSTRAINT�ALTER TABLE ONLY public.clients_products_fkey
    ADD CONSTRAINT clients_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
[ALTER TABLE ONLY public.clients_products DROP CONSTRAINT clients_products_product_id_fkey;
FK CONSTRAINT�ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.clients(id);
HALTER TABLE ONLY public.orders DROP CONSTRAINT orders_customer_id_fkey;
x�%�Mn�@cardofalse3349210212�
        FןO�	*f&�g	��"ZEPuՍC�j��A�L\�+�8B.V�ݍ<���g�h6�R�0z
�_B�	YR�g�J�w�dr�q��=�:Ďk�0eإ#�p9\s"�xn�����������3M����;���
M�M��
ΠPh-j��B3�C)Z@��E;RKs�������	�B�60�1�R���Z����G�g
                                                    6\F?�؉B���;��*q���9f��[K�� ����F��M%d2ͩ��v6D�_Od����:^Y� 3�������:�����pl�
 ��w2
     �P�]��� 
lx�U����R/ad ��f'M�?,'��q�[��4��
            ��������{jG����l'\���1��R/�L��h0�.�&H&�֎�]\�w�7ln��j��0�,�-���{m���x�-��n�0��~����6��
j�������@�2-i��;rl'�E�cp?�b�������� ��A�6��Wn^I&����nx�Ck]���KJ%�����؊zd��폒tK���]<�ricardo@pop-os:~/code/data_engineering$ 

