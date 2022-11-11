USE [master]
GO
/****** Object:  Database [DatabaseTestDBDocker]    Script Date: 06.11.2022 22:30:23 ******/
CREATE DATABASE [DatabaseTestDBDocker]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DatabaseTestDBDocker', FILENAME = N'/var/opt/mssql/data/DatabaseTestDBDocker.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DatabaseTestDBDocker_log', FILENAME = N'/var/opt/mssql/data/DatabaseTestDBDocker_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

/* Изменение кодировки */
ALTER DATABASE [DatabaseTestDBDocker]
COLLATE Cyrillic_General_CI_AS;
GO

ALTER DATABASE [DatabaseTestDBDocker] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DatabaseTestDBDocker].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ANSI_NULLS ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ANSI_PADDING ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ARITHABORT ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET RECOVERY FULL 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET  MULTI_USER 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [DatabaseTestDBDocker] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DatabaseTestDBDocker] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DatabaseTestDBDocker', N'ON'
GO
ALTER DATABASE [DatabaseTestDBDocker] SET QUERY_STORE = OFF
GO
USE [DatabaseTestDBDocker]
GO
USE [DatabaseTestDBDocker]
GO
/****** Object:  Sequence [dbo].[SEQ_KURS]    Script Date: 06.11.2022 22:30:23 ******/
CREATE SEQUENCE [dbo].[SEQ_KURS] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE  10 
GO
USE [DatabaseTestDBDocker]
GO
/****** Object:  Sequence [dbo].[SEQ_KURS_HIST]    Script Date: 06.11.2022 22:30:23 ******/
CREATE SEQUENCE [dbo].[SEQ_KURS_HIST] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE  10 
GO
USE [DatabaseTestDBDocker]
GO
/****** Object:  Sequence [dbo].[SEQ_KURS_SSIS_ID_EXT]    Script Date: 06.11.2022 22:30:23 ******/
CREATE SEQUENCE [dbo].[SEQ_KURS_SSIS_ID_EXT] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE  10 
GO
/****** Object:  UserDefinedTableType [dbo].[t_erb_minfin]    Script Date: 06.11.2022 22:30:23 ******/
CREATE TYPE [dbo].[t_erb_minfin] AS TABLE(
	[issuccess] [nvarchar](max) NULL,
	[num_rows] [numeric](38, 0) NULL,
	[requestdate] [datetime2](7) NULL,
	[isoverflow] [nvarchar](max) NULL,
	[errMsg] [nvarchar](max) NULL,
	[num_id] [numeric](38, 0) NULL,
	[root_id] [numeric](38, 0) NULL,
	[lastname] [nvarchar](max) NULL,
	[firstname] [nvarchar](max) NULL,
	[middlename] [nvarchar](max) NULL,
	[birthdate] [date] NULL,
	[publisher] [nvarchar](max) NULL,
	[departmentcode] [nvarchar](max) NULL,
	[departmentname] [nvarchar](max) NULL,
	[departmentphone] [nvarchar](max) NULL,
	[executor] [nvarchar](max) NULL,
	[executorphone] [nvarchar](max) NULL,
	[executoremail] [nvarchar](max) NULL,
	[deductiontype] [nvarchar](max) NULL,
	[vpnum] [nvarchar](max) NULL,
	[okpo] [nvarchar](max) NULL,
	[full_name] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[t_read_kurs_nbu]    Script Date: 06.11.2022 22:30:23 ******/
CREATE TYPE [dbo].[t_read_kurs_nbu] AS TABLE(
	[r030] [nvarchar](3) NULL,
	[txt] [nvarchar](max) NULL,
	[rate] [money] NULL,
	[cc] [nvarchar](3) NULL,
	[exchangedate] [date] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[base64_decode]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[base64_decode]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
-- Преобразование из base64
    RETURN (
        SELECT CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@p_text"))', 'VARBINARY(MAX)') AS NVARCHAR(MAX)) as rezult
    )	
END
GO
/****** Object:  UserDefinedFunction [dbo].[base64_encode]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[base64_encode]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
-- Преобразование в base64
    RETURN (
        SELECT
            CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'NVARCHAR(MAX)') as rezult
        FROM (
            SELECT CAST(@p_text AS VARBINARY(MAX)) AS bin
        ) AS bin_sql_server_temp
    )
END
GO
/****** Object:  UserDefinedFunction [dbo].[convert_cp866_to_1251]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[convert_cp866_to_1251]
(
	@instr varchar(8000)	
)
RETURNS varchar(8000)
AS
BEGIN
  -- Преобразование теста из cp866 в другую кодировку win1251 (для небольших объемов текста)
  declare @res varchar(8000)
  set @res = ''
  if not (@instr is null) begin
    declare @i as int
    declare @n as int
    declare @char_code_866 as int
    declare @char_code_1251 as int
    set @n = datalength(@instr)
    set @i = 1

    while @i<=@n begin
      set @char_code_866  = ascii(substring(@instr, @i, 1))
      select @char_code_1251 = 
        case   @char_code_866
          when  15 then 164
          when  20 then 182
          when  21 then 167
          when 128 then 192
          when 129 then 193
          when 130 then 194
          when 131 then 195
          when 132 then 196
          when 133 then 197
          when 134 then 198
          when 135 then 199
          when 136 then 200
          when 137 then 201
          when 138 then 202
          when 139 then 203
          when 140 then 204
          when 141 then 205
          when 142 then 206
          when 143 then 207
          when 144 then 208
          when 145 then 209
          when 146 then 210
          when 147 then 211
          when 148 then 212
          when 149 then 213
          when 150 then 214
          when 151 then 215
          when 152 then 216
          when 153 then 217
          when 154 then 218
          when 155 then 219
          when 156 then 220
          when 157 then 221
          when 158 then 222
          when 159 then 223
          when 160 then 224
          when 161 then 225
          when 162 then 226
          when 163 then 227
          when 164 then 228
          when 165 then 229
          when 166 then 230
          when 167 then 231
          when 168 then 232
          when 169 then 233
          when 170 then 234
          when 171 then 235
          when 172 then 236
          when 173 then 237
          when 174 then 238
          when 175 then 239
          when 176 then  45
          when 177 then  45
          when 178 then  45
          when 179 then 166
          when 180 then  43
          when 181 then 166
          when 182 then 166
          when 183 then 172
          when 184 then 172
          when 185 then 166
          when 186 then 166
          when 187 then 172
          when 188 then  45
          when 189 then  45
          when 190 then  45
          when 191 then 172
          when 192 then  76
          when 193 then  43
          when 194 then  84
          when 195 then  43
          when 196 then  45
          when 197 then  43
          when 198 then 166
          when 199 then 166
          when 200 then  76
          when 201 then 227
          when 202 then 166
          when 203 then  84
          when 204 then 166
          when 205 then  61
          when 206 then  43
          when 207 then 166
          when 208 then 166
          when 209 then  84
          when 210 then  84
          when 211 then  76
          when 212 then  76
          when 213 then  45
          when 214 then 227
          when 215 then  43
          when 216 then  43
          when 217 then  45
          when 218 then  45
          when 219 then  45
          when 220 then  45
          when 221 then 166
          when 222 then 166
          when 223 then  45
          when 224 then 240
          when 225 then 241
          when 226 then 242
          when 227 then 243
          when 228 then 244
          when 229 then 245
          when 230 then 246
          when 231 then 247
          when 232 then 248
          when 233 then 249
          when 234 then 250
          when 235 then 251
          when 236 then 252
          when 237 then 253
          when 238 then 254
          when 239 then 255
          when 240 then 168
          when 241 then 184
          when 242 then 170
          when 243 then 186
          when 244 then 175
          when 245 then 191
          when 246 then 161
          when 247 then 162
          when 248 then 176
          when 249 then 149
          when 250 then 183
          when 251 then 118
          when 252 then 185
          when 253 then 164
          when 254 then 166
          when 255 then 160

          else
            @char_code_866
        end

      set @res = @res + char(@char_code_1251)
      set @i = @i + 1
    end
  end
  return @res
END
GO
/****** Object:  UserDefinedFunction [dbo].[get_datetime]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_datetime]
(
	@p_text VARCHAR(100)	
)
RETURNS DATETIME2
AS
BEGIN
    -- Преобразование текста в дату и время
    DECLARE @m_date datetime2;

    if @p_text in ('null', 'nul') 
           RETURN null

    if len(@p_text) > 20    
        SET @m_date = CONVERT( DATETIME2, @p_text, 126 ); -- 'YYYY-MM-DD"T"hh24:mi:ss.FF9"Z"'

    else if len(@p_text) = 20    
        SET @m_date = CONVERT( DATETIME2, @p_text, 120 ); -- 'YYYY-MM-DD"T"hh24:mi:ss"Z"'        
        
    else if len(@p_text) = 17    
        SET @m_date = CONVERT( DATETIME2, replace(@p_text, 'Z', ':00'), 120 ); -- 'YYYY-MM-DD"T"hh24:mi"Z"'

	RETURN @m_date
END
GO
/****** Object:  UserDefinedFunction [dbo].[instr]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[instr]
(
	@str VARCHAR(8000), 
	@substr VARCHAR(255), 
	@start INT = 1, 
    @occurrence INT	= 1
)
RETURNS INT
AS
  BEGIN
-- Oracle функция INSTR возвращает n-е вхождение подстроки в строке.
-- @strin = является строка для поиска
-- @substr = подстрока для поиска в строке
-- @start = является положение символа в строке, с которого начнется поиск. Если параметр отрицательный, то функция рассчитывает позицию start_position в обратном направлении от конца строки, а затем ищет к началу строки.
-- @occurrence = является n-м вхождением подстроки

    DECLARE @found INT = @occurrence,
            @pos INT = @start;

    WHILE 1=1 
    BEGIN
        -- Find the next occurrence
        SET @pos = CHARINDEX(@substr, @str, @pos);

        -- Nothing found
        IF @pos IS NULL OR @pos = 0
            RETURN @pos;

        -- The required occurrence found
        IF @found = 1
            BREAK;

        -- Prepare to find another one occurrence
        SET @found = @found - 1;
        SET @pos = @pos + 1;
    END

    RETURN @pos;
  END
GO
/****** Object:  UserDefinedFunction [dbo].[is_valid_json]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[is_valid_json]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS CHAR(1)
AS
BEGIN
-- Проверка валидности JSON
  RETURN CASE WHEN ISJSON(@p_text) > 0
          THEN 'T'
          ELSE 'F'
          END
END
GO
/****** Object:  UserDefinedFunction [dbo].[is_valid_xml]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[is_valid_xml]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS CHAR(1)
AS
BEGIN   
-- Проверка валидности XML
  RETURN CASE WHEN TRY_CAST([dbo].[str_xml_format](@p_text) AS XML) IS NOT NULL
          THEN 'T'
          ELSE 'F' 
          END
END
GO
/****** Object:  UserDefinedFunction [dbo].[lpad]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[lpad]
(
    @string NVARCHAR(MAX), -- Initial string
    @length INT,           -- Size of final string
    @pad NVARCHAR(MAX)     -- Pad string
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    -- LPAD добавляет с левой части строки определенный набор символов (при не нулевом @string).
    RETURN SUBSTRING(REPLICATE(@pad, @length),1,@length - LEN(@string)) + @string;
END
GO
/****** Object:  UserDefinedFunction [dbo].[num_to_str]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[num_to_str]
(
	@p_amount NUMERIC(38,15)   
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
     -- Преобразование числа в текст
     IF @p_amount is null 
         return '';
          
     RETURN FORMAT(@p_amount,'0.0##############')
END
GO
/****** Object:  UserDefinedFunction [dbo].[rpad]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[rpad]
(
    @string NVARCHAR(MAX), -- Initial string
    @length INT,           -- Size of final string
    @pad NVARCHAR(MAX)     -- Pad string
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    -- RPAD дополняет с правой части строки определенный набор символов (при не нулевом @string).
    RETURN @string + SUBSTRING(REPLICATE(@pad, @length),1,@length - LEN(@string));
END
GO
/****** Object:  UserDefinedFunction [dbo].[split_part]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[split_part]
(
	@str NVARCHAR(MAX),
	@substr NVARCHAR(1) = ';',
	@occurrence INT	= 1
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- получить часть теста из строки
	DECLARE @m_str NVARCHAR(MAX) = @str;
	SET @m_str = REPLACE(REPLACE(@m_str, char(10),''), char(13),'');
	IF SUBSTRING(@m_str, LEN(@m_str), 1) != @substr
	     SET @m_str = @m_str + @substr
	
	IF @occurrence > LEN(@m_str) - LEN(REPLACE(@m_str, @substr, ''))
	     RETURN ''

	IF @occurrence = 1
	      SET @m_str = SUBSTRING(@m_str, 1, [dbo].[instr](@m_str, @substr, default, @occurrence) - 1)
    ELSE
	      SET @m_str = SUBSTRING(@m_str, [dbo].[instr](@m_str, @substr, default, @occurrence - 1) + 1, [dbo].[instr](@m_str, @substr, default, @occurrence) - [dbo].[instr](@m_str, @substr, default, @occurrence - 1) - 1)

	RETURN @m_str	
END
GO
/****** Object:  UserDefinedFunction [dbo].[str_amount]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_amount]
(
	@p_amount MONEY,
    @p_suffix NVARCHAR(3) = ''
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Преобразование суммы в текст             
    -- p_suffix - UAH, USD, EUR, GBP, CHF, RUB - валюта
    -- p_suffix - _WH - цiлих, сотих
    -- p_suffix - _WR - для %
    DECLARE @Res NVARCHAR(255), @a1 NVARCHAR(40), @a2 NCHAR(3), @b1 NCHAR(1), @b2 NCHAR(1), @b3 NCHAR(1)
    DECLARE @i int
    DECLARE @temp_amount money = @p_amount

    if @p_suffix = ''
         SET @temp_amount = floor(abs(@temp_amount))

    SET @a1 = Convert(NVARCHAR(255), abs(@temp_amount))    
    SET @i = CharIndex('.', @a1)
    if @i > 0
        SET @a1 = Substring(@a1,1,@i-1)

    -- единицы
    SET @a1 = Replicate(' ',20) + @a1
    SET @a2 = Right(@a1,3)
    SET @b1 = Substring(@a2, 1, 1)
    SET @b2 = Substring(@a2, 2, 1)
    SET @b3 = Substring(@a2, 3, 1)

    if @p_suffix in ('', '_WR')
        SET @Res = ' '
    
    if @b3 = '1' and @b2 != '1' 
        begin
         if @p_suffix = 'UAH' SET @Res = ' гривня' else
         if @p_suffix = 'USD' SET @Res = ' долар США' else
         if @p_suffix = 'EUR' SET @Res = ' євро' else
         if @p_suffix = 'GBP' SET @Res = ' англійських Фунт стерлінгів' else
         if @p_suffix = 'CHF' SET @Res = ' швейцарський франк' else
         if @p_suffix = 'RUB' SET @Res = ' російський рубль' else
         if @p_suffix = '_WH' SET @Res = ' цiлих'
       end
    else if @b3 in ('2','3','4') and @b2 != '1' 
        begin
         if @p_suffix = 'UAH' SET @Res = ' гривні' else
         if @p_suffix = 'USD' SET @Res = ' долари США' else
         if @p_suffix = 'EUR' SET @Res = ' євро' else
         if @p_suffix = 'GBP' SET @Res = ' англійських Фунти стерлінгів' else
         if @p_suffix = 'CHF' SET @Res = ' швейцарських франки' else
         if @p_suffix = 'RUB' SET @Res = ' російських рубля' else
         if @p_suffix = '_WH' SET @Res = ' цiлих'
       end        
    else 
        begin
         if @p_suffix = 'UAH' SET @Res = ' гривень' else
         if @p_suffix = 'USD' SET @Res = ' доларiв США' else
         if @p_suffix = 'EUR' SET @Res = ' євро' else
         if @p_suffix = 'GBP' SET @Res = ' англійських Фунтів стерлінгів' else
         if @p_suffix = 'CHF' SET @Res = ' швейцарських франків' else
         if @p_suffix = 'RUB' SET @Res = ' російських рублів' else
         if @p_suffix = '_WH' SET @Res = ' цiлих'
       end

    if @temp_amount = 0 SET @Res = ' нуль' + @Res    
    if @temp_amount >= 1
       BEGIN
            if @b2 = '1' 
              begin
                if @b3 = '0' SET @Res = ' десять' + @Res else
                if @b3 = '1' SET @Res = ' одинадцать' + @Res else
                if @b3 = '2' SET @Res = ' дванадцять' + @Res else
                if @b3 = '3' SET @Res = ' тринадцать' + @Res else
                if @b3 = '4' SET @Res = ' чотирнадцять' + @Res else
                if @b3 = '5' SET @Res = ' п''ятнадцять' + @Res else
                if @b3 = '6' SET @Res = ' шiстнадцять' + @Res else
                if @b3 = '7' SET @Res = ' сiмнадцять' + @Res else
                if @b3 = '8' SET @Res = ' вiсiмнадцять' + @Res else
                if @b3 = '9' SET @Res = ' дев''ятнадцять' + @Res
              end
            else
              begin
                if @p_suffix in ('UAH', '_WR')
                   BEGIN
                    if @b3 = '1' SET @Res = ' одна' + @Res else
                    if @b3 = '2' SET @Res = ' двi' + @Res else
                    if @b3 = '3' SET @Res = ' три' + @Res else
                    if @b3 = '4' SET @Res = ' чотири' + @Res else
                    if @b3 = '5' SET @Res = ' п''ять' + @Res else
                    if @b3 = '6' SET @Res = ' шiсть' + @Res else
                    if @b3 = '7' SET @Res = ' сiм' + @Res else
                    if @b3 = '8' SET @Res = ' вiсiм' + @Res else
                    if @b3 = '9' SET @Res = ' дев''ять' + @Res
                   END
                else
                   BEGIN
                    if @b3 = '1' SET @Res = ' один' + @Res else
                    if @b3 = '2' SET @Res = ' два' + @Res else
                    if @b3 = '3' SET @Res = ' три' + @Res else
                    if @b3 = '4' SET @Res = ' чотири' + @Res else
                    if @b3 = '5' SET @Res = ' п''ять' + @Res else
                    if @b3 = '6' SET @Res = ' шiсть' + @Res else
                    if @b3 = '7' SET @Res = ' сiм' + @Res else
                    if @b3 = '8' SET @Res = ' вiсiм' + @Res else
                    if @b3 = '9' SET @Res = ' дев''ять' + @Res
                   END

                if @b2 = '2' SET @Res = ' двадцять' + @Res else
                if @b2 = '3' SET @Res = ' тридцять' + @Res else
                if @b2 = '4' SET @Res = ' сорок' + @Res else
                if @b2 = '5' SET @Res = ' п''ятдесят' + @Res else
                if @b2 = '6' SET @Res = ' шiстдесят' + @Res else
                if @b2 = '7' SET @Res = ' сiмдесят' + @Res else
                if @b2 = '8' SET @Res = ' вiсiмдесят' + @Res else
                if @b2 = '9' SET @Res = ' дев''яносто' + @Res
              end
                if @b1 = '1' SET @Res = ' сто' + @Res else
                if @b1 = '2' SET @Res = ' двiстi' + @Res else
                if @b1 = '3' SET @Res = ' триста' + @Res else
                if @b1 = '4' SET @Res = ' чотириста' + @Res else
                if @b1 = '5' SET @Res = ' п''ятсот' + @Res else
                if @b1 = '6' SET @Res = ' шiстсот' + @Res else
                if @b1 = '7' SET @Res = ' сiмсот' + @Res else
                if @b1 = '8' SET @Res = ' вiсiмсот' + @Res else
                if @b1 = '9' SET @Res = ' дев''ятсот' + @Res
       END

    -- тисячи
    if @temp_amount >= 1000
       BEGIN
            SET @a1 = Substring(@a1,1,datalength(@a1)-3)
            SET @a2 = Right(@a1,3)
            SET @b1 = Substring(@a2,1,1)
            SET @b2 = Substring(@a2,2,1)
            SET @b3 = Substring(@a2,3,1)

            if @b3 = '0' and @b2 = '0' and @b1 = '0'
             SET @res = @res
            else
            begin
             if @b3 = '1' and @b2 != '1' 
              SET @Res = ' тисяча' + @Res 
             else if @b3 in ('2','3','4') and @b2 != '1' 
              SET @Res = ' тисячi' + @Res
             else if @a2 != '   '
              SET @Res = ' тисяч' + @Res
            end
            if @b2 = '1' 
              begin
                if @b3 = '0' SET @Res = ' десять' + @Res else
                if @b3 = '1' SET @Res = ' одинадцать' + @Res else
                if @b3 = '2' SET @Res = ' дванадцять' + @Res else
                if @b3 = '3' SET @Res = ' тринадцать' + @Res else
                if @b3 = '4' SET @Res = ' чотирнадцять' + @Res else
                if @b3 = '5' SET @Res = ' п''ятнадцять' + @Res else
                if @b3 = '6' SET @Res = ' шiстнадцять' + @Res else
                if @b3 = '7' SET @Res = ' сiмнадцять' + @Res else
                if @b3 = '8' SET @Res = ' вiсiмнадцять' + @Res else
                if @b3 = '9' SET @Res = ' дев''ятнадцять' + @Res
              end
            else
              begin
                if @b3 = '1' SET @Res = ' одна' + @Res else
                if @b3 = '2' SET @Res = ' двi' + @Res else
                if @b3 = '3' SET @Res = ' три' + @Res else
                if @b3 = '4' SET @Res = ' чотири' + @Res else
                if @b3 = '5' SET @Res = ' п''ять' + @Res else
                if @b3 = '6' SET @Res = ' шiсть' + @Res else
                if @b3 = '7' SET @Res = ' сiм' + @Res else
                if @b3 = '8' SET @Res = ' вiсiм' + @Res else
                if @b3 = '9' SET @Res = ' дев''ять' + @Res

                if @b2 = '2' SET @Res = ' двадцять' + @Res else
                if @b2 = '3' SET @Res = ' тридцять' + @Res else
                if @b2 = '4' SET @Res = ' сорок' + @Res else
                if @b2 = '5' SET @Res = ' п''ятдесят' + @Res else
                if @b2 = '6' SET @Res = ' шiстдесят' + @Res else
                if @b2 = '7' SET @Res = ' сiмдесят' + @Res else
                if @b2 = '8' SET @Res = ' вiсiмдесят' + @Res else
                if @b2 = '9' SET @Res = ' дев''яносто' + @Res
              end
                if @b1 = '1' SET @Res = ' сто' + @Res else
                if @b1 = '2' SET @Res = ' двiстi' + @Res else
                if @b1 = '3' SET @Res = ' триста' + @Res else
                if @b1 = '4' SET @Res = ' чотириста' + @Res else
                if @b1 = '5' SET @Res = ' п''ятсот' + @Res else
                if @b1 = '6' SET @Res = ' шiстсот' + @Res else
                if @b1 = '7' SET @Res = ' сiмсот' + @Res else
                if @b1 = '8' SET @Res = ' вiсiмсот' + @Res else
                if @b1 = '9' SET @Res = ' дев''ятсот' + @Res
       END

    -- миллионы
    if @temp_amount >= 1000000
       BEGIN            
            SET @a1 = Substring(@a1,1,datalength(@a1)-3)
            SET @a2 = Right(@a1,3)
            SET @b1 = Substring(@a2,1,1)
            SET @b2 = Substring(@a2,2,1)
            SET @b3 = Substring(@a2,3,1)
            if @b3 = '0' and @b2 = '0' and @b1 = '0'
             SET @res = @res
            else
            begin
            if @b3 = '1' and @b2 != '1' 
             SET @Res = ' мiльйон' + @Res
            else if @b3 in ('2','3','4') and @b2 != '1' 
             SET @Res = ' мiльйона' + @Res
            else if @a2 != '   '
             SET @Res = ' мiльйонiв' + @Res
            end
            if @b2 = '1' 
              begin
                if @b3 = '0' SET @Res = ' десять' + @Res else
                if @b3 = '1' SET @Res = ' одинадцать' + @Res else
                if @b3 = '2' SET @Res = ' дванадцять' + @Res else
                if @b3 = '3' SET @Res = ' тринадцать' + @Res else
                if @b3 = '4' SET @Res = ' чотирнадцять' + @Res else
                if @b3 = '5' SET @Res = ' п''ятнадцять' + @Res else
                if @b3 = '6' SET @Res = ' шiстнадцять' + @Res else
                if @b3 = '7' SET @Res = ' сiмнадцять' + @Res else
                if @b3 = '8' SET @Res = ' вiсiмнадцять' + @Res else
                if @b3 = '9' SET @Res = ' дев''ятнадцять' + @Res
              end
            else
              begin
                if @b3 = '1' SET @Res = ' один' + @Res else
                if @b3 = '2' SET @Res = ' два' + @Res else
                if @b3 = '3' SET @Res = ' три' + @Res else
                if @b3 = '4' SET @Res = ' чотири' + @Res else
                if @b3 = '5' SET @Res = ' п''ять' + @Res else
                if @b3 = '6' SET @Res = ' шiсть' + @Res else
                if @b3 = '7' SET @Res = ' сiм' + @Res else
                if @b3 = '8' SET @Res = ' вiсiм' + @Res else
                if @b3 = '9' SET @Res = ' дев''ять' + @Res

                if @b2 = '2' SET @Res = ' двадцять' + @Res else
                if @b2 = '3' SET @Res = ' тридцять' + @Res else
                if @b2 = '4' SET @Res = ' сорок' + @Res else
                if @b2 = '5' SET @Res = ' п''ятдесят' + @Res else
                if @b2 = '6' SET @Res = ' шiстдесят' + @Res else
                if @b2 = '7' SET @Res = ' сiмдесят' + @Res else
                if @b2 = '8' SET @Res = ' вiсiмдесят' + @Res else
                if @b2 = '9' SET @Res = ' дев''яносто' + @Res
              end
                if @b1 = '1' SET @Res = ' сто' + @Res else
                if @b1 = '2' SET @Res = ' двiстi' + @Res else
                if @b1 = '3' SET @Res = ' триста' + @Res else
                if @b1 = '4' SET @Res = ' чотириста' + @Res else
                if @b1 = '5' SET @Res = ' п''ятсот' + @Res else
                if @b1 = '6' SET @Res = ' шiстсот' + @Res else
                if @b1 = '7' SET @Res = ' сiмсот' + @Res else
                if @b1 = '8' SET @Res = ' вiсiмсот' + @Res else
                if @b1 = '9' SET @Res = ' дев''ятсот' + @Res
       END

    -- миллиарды
    if @temp_amount >= 1000000000
       BEGIN
            SET @a1 = Substring(@a1,1,datalength(@a1)-3)
            SET @a2 = Right(@a1,3)
            SET @b1 = Substring(@a2,1,1)
            SET @b2 = Substring(@a2,2,1)
            SET @b3 = Substring(@a2,3,1)
            if @b3 = '0' and @b2 = '0' and @b1 = '0'
             SET @res = @res
            else
            begin
            if @b3 = '1' and @b2 != '1' 
             SET @Res = ' мiльярд' + @Res
            else if @b3 in ('2','3','4') and @b2 != '1' 
             SET @Res = ' мiльярда' + @Res
            else if @a2 != '   '
             SET @Res = ' мiльярдiв' + @Res
            end
            if @b2 = '1' 
              begin
                if @b3 = '0' SET @Res = ' десять' + @Res else
                if @b3 = '1' SET @Res = ' одинадцать' + @Res else
                if @b3 = '2' SET @Res = ' дванадцять' + @Res else
                if @b3 = '3' SET @Res = ' тринадцать' + @Res else
                if @b3 = '4' SET @Res = ' чотирнадцять' + @Res else
                if @b3 = '5' SET @Res = ' п''ятнадцять' + @Res else
                if @b3 = '6' SET @Res = ' шiстнадцять' + @Res else
                if @b3 = '7' SET @Res = ' сiмнадцять' + @Res else
                if @b3 = '8' SET @Res = ' вiсiмнадцять' + @Res else
                if @b3 = '9' SET @Res = ' дев''ятнадцять' + @Res
              end
            else
              begin
                if @b3 = '1' SET @Res = ' один' + @Res else
                if @b3 = '2' SET @Res = ' два' + @Res else
                if @b3 = '3' SET @Res = ' три' + @Res else
                if @b3 = '4' SET @Res = ' чотири' + @Res else
                if @b3 = '5' SET @Res = ' п''ять' + @Res else
                if @b3 = '6' SET @Res = ' шiсть' + @Res else
                if @b3 = '7' SET @Res = ' сiм' + @Res else
                if @b3 = '8' SET @Res = ' вiсiм' + @Res else
                if @b3 = '9' SET @Res = ' дев''ять' + @Res

                if @b2 = '2' SET @Res = ' двадцять' + @Res else
                if @b2 = '3' SET @Res = ' тридцять' + @Res else
                if @b2 = '4' SET @Res = ' сорок' + @Res else
                if @b2 = '5' SET @Res = ' п''ятдесят' + @Res else
                if @b2 = '6' SET @Res = ' шiстдесят' + @Res else
                if @b2 = '7' SET @Res = ' сiмдесят' + @Res else
                if @b2 = '8' SET @Res = ' вiсiмдесят' + @Res else
                if @b2 = '9' SET @Res = ' дев''яносто' + @Res
              end
                if @b1 = '1' SET @Res = ' сто' + @Res else
                if @b1 = '2' SET @Res = ' двiстi' + @Res else
                if @b1 = '3' SET @Res = ' триста' + @Res else
                if @b1 = '4' SET @Res = ' чотириста' + @Res else
                if @b1 = '5' SET @Res = ' п''ятсот' + @Res else
                if @b1 = '6' SET @Res = ' шiстсот' + @Res else
                if @b1 = '7' SET @Res = ' сiмсот' + @Res else
                if @b1 = '8' SET @Res = ' вiсiмсот' + @Res else
                if @b1 = '9' SET @Res = ' дев''ятсот' + @Res
       END    

    DECLARE @mb NCHAR(50), @bb NCHAR(50)
    SET @mb = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя'''
    SET @bb = 'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ'''
    SET @i = CharIndex(substring(@Res,1,1),@mb)
    SET @Res = Substring(@bb,@i,1) + Substring(@Res,2,255)
    SET @Res = upper(Substring(@Res,1,1)) + Substring(@Res,2, 254)
    
    DECLARE @kop NVARCHAR(2)
    DECLARE @mkop money
    DECLARE @suffix NVARCHAR(20)
    SET @kop = right(convert(NVARCHAR(255),abs(@temp_amount)),2)
    SET @mkop = convert(money,@kop)

    if @p_suffix = 'UAH'
            SET @suffix = case
                             when @mkop = 0 then ' копійок'
                             when @mkop > 10 and @mkop < 20 then ' копійок'
                             when right(@kop,1) = '1' then ' копійка'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' копійки'
                             else ' копійок'
                          end
    else
    if @p_suffix =  'USD'
            SET @suffix = case
                             when @mkop = 0 then ' центiв'
                             when @mkop > 10 and @mkop < 20 then ' центiв'
                             when right(@kop,1) = '1' then ' цент'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' центи'
                             else ' центiв'
                          end
    else
    if @p_suffix = 'EUR'         
            SET @suffix = case
                             when @mkop = 0 then ' євроцентiв'
                             when @mkop > 10 and @mkop < 20 then ' євроцентiв'
                             when right(@kop,1) = '1' then ' євроцент'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' євроценти'
                             else ' євроцентiв'
                          end        
    else
    if @p_suffix = 'GBP'
            SET @suffix = case
                             when @mkop = 0 then ' пенсiв'
                             when @mkop > 10 and @mkop < 20 then ' пенсiв'
                             when right(@kop,1) = '1' then ' пенс'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' пенси'
                             else ' пенсiв'
                          end
    else
    if @p_suffix = 'CHF'
            SET @suffix = case
                             when @mkop = 0 then ' сантимiв'
                             when @mkop > 10 and @mkop < 20 then ' сантимiв'
                             when right(@kop,1) = '1' then ' сантим'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' сантими'
                             else ' сантимiв'
                          end
    else
    if @p_suffix = 'RUB'
            SET @suffix = case
                             when @mkop = 0 then ' копійок'
                             when @mkop > 10 and @mkop < 20 then ' копійок'
                             when right(@kop,1) = '1' then ' копійка'
                             when right(@kop,1) > '1' and right(@kop,1) < '5' then ' копійки'
                             else ' копійок'
                          end
    else
    if @p_suffix = '_WH'
            SET @suffix = ' сотих';
    
    if @p_suffix in ('', '_WR')
        SET @Res = @Res
    else
        SET @Res = @Res + ' ' + @kop + @suffix

    SET @Res = trim(upper(Substring(Ltrim(@Res),1,1)) + Substring(ltrim(@Res),2, 254))
 
    return @Res;

END
GO
/****** Object:  UserDefinedFunction [dbo].[str_amount_format]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_amount_format]
(
	@p_number MONEY,
	@p_count_comma INT = 2
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Преобразование суммы в текстовый формат числа
    DECLARE @p_rezult NVARCHAR(255);

    if @p_number is null 
        return '';

    if @p_count_comma = 0  SET @p_rezult = format(@p_number,'### ### ### ### ##0') else
    if @p_count_comma = 1  SET @p_rezult = format(@p_number,'### ### ### ### ##0.0') else
    if @p_count_comma = 2  SET @p_rezult = format(@p_number,'### ### ### ### ##0.00') else
    if @p_count_comma = 3  SET @p_rezult = format(@p_number,'### ### ### ### ##0.000') else
    if @p_count_comma >= 4  SET @p_rezult = format(@p_number,'### ### ### ### ##0.0000')    

    return @p_rezult;
END
GO
/****** Object:  UserDefinedFunction [dbo].[str_interest]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_interest]
(
	@p_amount NUMERIC(38,8) -- точность 8 знаков
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Преобразование процента с тест (0,5678999% (нуль цiлих i п'ять мiльйонiв шiстсот сiмдесят вiсiм тисяч дев'ятсот дев'яносто дев'ять десятимільйонних процента))
    DECLARE @p_result      NVARCHAR(255) = '';       
    DECLARE @mFractionDR   BIGINT;
    DECLARE @tFractionDR   NVARCHAR(255);
    DECLARE @FractionType  NVARCHAR(255);
    DECLARE @mFractionCC   BIGINT;
    DECLARE @tFractionCC   NVARCHAR(255);
    DECLARE @FractionL     NVARCHAR(1);    
    --    
    SET @mFractionCC = convert(BIGINT, @p_amount); -- выделяем целую часть       
    SET @tFractionCC = convert(NVARCHAR(255), @mFractionCC);
    ---------------------------------------------------------
    SET @mFractionDR = (@p_amount - @mFractionCC)*100000000; -- выделяем дробную часть *100000000
    SET @tFractionDR = dbo.num_to_str(@mFractionDR); -- преобразуем в текст
    SET @tFractionDR = Right(Replicate('0', 10) + @tFractionDR, 10); -- дополнить до 8-ми
    SET @tFractionDR = substring(@tFractionDR, 1, len(@tFractionDR)-2); -- убираем .0    
    SET @tFractionDR = left(@tFractionDR, len(replace(@tFractionDR, '0', ' '))) -- убираем лишние 0 справа    
    SET @mFractionDR = convert(BIGINT, @tFractionDR) -- получение дробной суммы
    ---------------------------------------------------------
    if len(@tFractionDR) = 1 SET @FractionType = 'десятих'; else
    if len(@tFractionDR) = 2 SET @FractionType = 'сотих'; else
    if len(@tFractionDR) = 3 SET @FractionType = 'тисячних'; else
    if len(@tFractionDR) = 4 SET @FractionType = 'десятитисячних'; else
    if len(@tFractionDR) = 5 SET @FractionType = 'стотисячних'; else
    if len(@tFractionDR) = 6 SET @FractionType = 'мільйонних'; else
    if len(@tFractionDR) = 7 SET @FractionType = 'десятимільйонних'; else
    if len(@tFractionDR) = 8 SET @FractionType = 'стомільйонних';

    -- если дробной части нет
    IF @mFractionDR = 0
     BEGIN
      SET @p_result = dbo.num_to_str(@p_amount) + '% (' + dbo.str_amount(@p_amount, default);
      --
      SET @FractionL = substring(@tFractionCC, len(@tFractionCC), 1);           
      IF (@FractionL in ('0','5','6','7','8','9') or @p_amount in (11,12,13,14,15,16,17,18,19)) 
            SET @p_result = @p_result + ' процентiв)';
      ELSE IF @FractionL = '1' 
            SET @p_result = @p_result + ' процент)';
      ELSE IF @FractionL in ('2','3','4') 
            SET @p_result = @p_result + ' процента)';
      ELSE
         SET @p_result = @p_result + ' процента)';      
     END
    ELSE
     BEGIN
      SET @p_result = dbo.num_to_str(@p_amount) + '% (' + dbo.str_amount(@mFractionCC, '_WR');

      IF @tFractionCC = '1' -- если целая часть = 1
          SET @p_result = @p_result + ' цiла i ' + lower(dbo.str_amount(@mFractionDR, '_WR')) + ' ' + @FractionType;
      ELSE
          SET @p_result = @p_result + ' цiлих i ' + lower(dbo.str_amount(@mFractionDR, '_WR')) + ' ' + @FractionType;      

      SET @p_result = @p_result + ' процента)';
     END    

    SET @p_result = lower(@p_result);
    
    -- замена
    IF @FractionType is not null and substring(@tFractionDR, len(@tFractionDR), 1) = '1' and substring(@tFractionDR, len(@tFractionDR) - 1, 2) != '11'              
      BEGIN
        if len(@tFractionDR) = 1 SET @p_result = replace(@p_result, 'десятих', 'десята'); else
        if len(@tFractionDR) = 2 SET @p_result = replace(@p_result, 'сотих', 'сота'); else
        if len(@tFractionDR) = 3 SET @p_result = replace(@p_result, 'тисячних', 'тисячна'); else
        if len(@tFractionDR) = 4 SET @p_result = replace(@p_result, 'десятитисячних', 'десятитисячна'); else
        if len(@tFractionDR) = 5 SET @p_result = replace(@p_result, 'стотисячних', 'стотисячна'); else
        if len(@tFractionDR) = 6 SET @p_result = replace(@p_result, 'мільйонних', 'мільйонна'); else
        if len(@tFractionDR) = 7 SET @p_result = replace(@p_result, 'десятимільйонних', 'десятимільйонна'); else
        if len(@tFractionDR) = 8 SET @p_result = replace(@p_result, 'стомільйонних', 'стомільйонна');        
      END      

    RETURN replace(trim(substring(@p_result, 1, 255)), '.', ',');	
END
GO
/****** Object:  UserDefinedFunction [dbo].[str_to_date_func]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_to_date_func]
(
	@p_text   NVARCHAR(MAX), 
	@p_format NVARCHAR(100) = 'dd.mm.yyyy'	
)
RETURNS DATE
AS
BEGIN
	-- Преобразование теста в дату
	DECLARE @m_format INT;

	IF (@p_text is null or @p_text = '') 
	    RETURN null;

	-- T-SQL syntax
	SET @m_format = CASE @p_format   
					WHEN 'mm/dd/yy' THEN 1     
					WHEN 'yy.mm.dd' THEN 2     
					WHEN 'dd/mm/yy' THEN 3     
					WHEN 'dd.mm.yy' THEN 4     
					WHEN 'dd-mm-yy' THEN 5     
					WHEN 'dd-Mon-yy' THEN 6     
					WHEN 'Mon dd, yy' THEN 7     
					WHEN 'mm-dd-yy' THEN 10     
					WHEN 'yy/mm/dd' THEN 11     
					WHEN 'yymmdd' THEN 12     
					WHEN 'yyyy-mm-dd' THEN 23
					WHEN 'mm/dd/yyyy' THEN 101     
					WHEN 'yyyy.mm.dd' THEN 102     
					WHEN 'dd/mm/yyyy' THEN 103     
					WHEN 'dd.mm.yyyy' THEN 104     
					WHEN 'dd-mm-yyyy' THEN 105     
					WHEN 'dd Mon yyyy' THEN 106     
					WHEN 'Mon dd, yyyy' THEN 107     
					WHEN 'mm-dd-yyyy' THEN 110
					WHEN 'yyyy/mm/dd' THEN 111
					WHEN 'yyyymmdd' THEN 112
					ELSE 0
					END   	 

	IF @m_format = 0
		RETURN null;
		
	RETURN TRY_CONVERT(date, @p_text, @m_format)
END
GO
/****** Object:  UserDefinedFunction [dbo].[str_to_num_func]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_to_num_func]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS NUMERIC(38, 15)
AS
BEGIN
-- Преобразование теста с число
    DECLARE @m_text NVARCHAR(MAX);    

	IF (@p_text is null or @p_text = '') 
	    RETURN null;

    SET @m_text = replace(@p_text,',','.');
    SET @m_text = replace(@p_text,' ','');
    SET @m_text = replace(@p_text,char(13),'');
    SET @m_text = replace(@p_text,char(10),'');
	
    RETURN TRY_CONVERT(NUMERIC(38, 15), @m_text)
END
GO
/****** Object:  UserDefinedFunction [dbo].[str_xml_format]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[str_xml_format]
(
	@p_text NVARCHAR(MAX)	
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Преобразование в правильный текстовый формат XML для дальнейшего преобразования.
	-- xml в MSSQL всегда в UTF-16
	RETURN REPLACE(REPLACE(REPLACE(CAST(@p_text AS NVARCHAR(MAX)),N'utf-8',N'utf-16'),N'.0,',N','),N'.00,',N',');
END
GO
/****** Object:  Table [dbo].[FAIR_VALUE]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAIR_VALUE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CALC_DATE] [date] NOT NULL,
	[ISIN] [nvarchar](30) NOT NULL,
	[CURRENCY_CODE] [nvarchar](3) NOT NULL,
	[FAIR_VALUE] [numeric](38, 15) NULL,
	[YTM] [numeric](38, 15) NULL,
	[CLEAN_RATE] [numeric](38, 15) NULL,
	[COR_COEF] [numeric](38, 15) NULL,
	[MATURITY] [date] NULL,
	[COR_COEF_CASH] [numeric](38, 15) NULL,
	[COR_COEF_SWAP] [numeric](38, 15) NULL,
	[NOTIONAL] [numeric](38, 15) NULL,
	[AVR_RATE] [numeric](38, 15) NULL,
	[OPTION_VALUE] [numeric](38, 15) NULL,
	[INTRINSIC_VALUE] [numeric](38, 15) NULL,
	[TIME_VALUE] [numeric](38, 15) NULL,
	[DELTA_PER] [numeric](38, 15) NULL,
	[DELTA_EQU] [numeric](38, 15) NULL,
	[GS_ZS_CPTYPE] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ISIN_SECUR]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ISIN_SECUR](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ISIN] [nvarchar](30) NOT NULL,
	[NOMINAL] [int] NULL,
	[AUK_PROC] [nchar](10) NULL,
	[PGS_DATE] [date] NULL,
	[RAZM_DATE] [date] NULL,
	[CPTYPE] [nvarchar](255) NULL,
	[CPDESCR] [nvarchar](255) NULL,
	[PAY_PERIOD] [nvarchar](255) NULL,
	[CURRENCY_CODE] [nvarchar](3) NULL,
	[EMIT_OKPO] [nvarchar](255) NULL,
	[EMIT_NAME] [nvarchar](255) NULL,
	[CPTYPE_NKCPFR] [nvarchar](255) NULL,
	[CPCODE_CFI] [nvarchar](255) NULL,
	[TOTAL_BONDS] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ISIN_SECUR_PAY]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ISIN_SECUR_PAY](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ISIN_SECUR_ID] [int] NOT NULL,
	[PAY_DATE] [date] NOT NULL,
	[PAY_TYPE] [int] NOT NULL,
	[PAY_VAL] [numeric](38, 15) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VIEW_FAIR_REPORT]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_FAIR_REPORT]
AS 
WITH FAIR_VALUE_LIST (ISIN, LAST_CALC_DATE, LAST_FAIR_VALUE) AS
(
	SELECT ff.ISIN,
		   MAX(ff.LAST_CALC_DATE) as LAST_CALC_DATE,
		   MAX(ff.LAST_FAIR_VALUE) as LAST_FAIR_VALUE
	FROM
	(
	 SELECT f.ISIN,
			FIRST_VALUE(f.CALC_DATE) OVER (PARTITION BY f.ISIN ORDER BY f.CALC_DATE DESC ROWS UNBOUNDED PRECEDING) AS LAST_CALC_DATE,
			FIRST_VALUE(f.FAIR_VALUE) OVER (PARTITION BY f.ISIN ORDER BY f.CALC_DATE DESC ROWS UNBOUNDED PRECEDING) AS LAST_FAIR_VALUE
	 FROM FAIR_VALUE f
	 WHERE f.CALC_DATE <= GETDATE()
	) ff
	GROUP BY ff.ISIN
)
SELECT s.ISIN,
       s.NOMINAL,
	   s.PAY_PERIOD,
	   s.EMIT_NAME,
	   sp.PAY_DATE,
	   CASE sp.PAY_TYPE
	     WHEN 1 THEN 'Выплата %'
		 WHEN 2 THEN 'Выплата купона'
	   END as PAY_TYPE,
	   sp.PAY_VAL,
	   f.LAST_FAIR_VALUE,
	   f.LAST_CALC_DATE
FROM ISIN_SECUR s
LEFT OUTER JOIN ISIN_SECUR_PAY sp on s.ID = sp.ISIN_SECUR_ID AND sp.PAY_DATE >= GETDATE()
LEFT OUTER JOIN FAIR_VALUE_LIST f on s.ISIN = f.ISIN
GO
/****** Object:  Table [dbo].[CURRENCY]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CURRENCY](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CODE] [nvarchar](3) NOT NULL,
	[NAME] [nvarchar](255) NOT NULL,
	[SHORT_NAME] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK_CURRENCY] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KURS]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KURS](
	[Id] [int] NOT NULL,
	[CURRENCY_CODE] [nvarchar](3) NOT NULL,
	[KURS_DATE] [date] NOT NULL,
	[RATE] [money] NOT NULL,
	[FORC] [int] NOT NULL,
	[SYS_DATE] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VIEW_KURS]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_KURS]
AS 
	SELECT k.CURRENCY_CODE,
	       c.SHORT_NAME as CURRENCY_SNAME,
		   c.NAME as CURRENCY_NAME,
		   k.KURS_DATE,
		   k.RATE,
		   k.FORC
	FROM [KURS] k
	INNER JOIN [CURRENCY] AS c ON c.CODE = k.CURRENCY_CODE
GO
/****** Object:  View [dbo].[VIEW_KURS_REPORT]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_KURS_REPORT]
	AS
WITH KURS_AVG_YEAR (PART_YEAR, CURRENCY_CODE, AVG_RATE) AS
(
  SELECT CONVERT(nvarchar(4), DATEPART(year,k.KURS_DATE)) AS PART_YEAR,
         k.CURRENCY_CODE,
         AVG(k.RATE/k.FORC) AS AVG_RATE
    FROM KURS k
GROUP BY CONVERT(nvarchar(4), DATEPART(year,k.KURS_DATE)), k.CURRENCY_CODE

),
KURS_AVG (PART_MONTH_DATE, CURRENCY_CODE, AVG_RATE) AS
                (
                SELECT f.PART_MONTH_DATE,
					   f.CURRENCY_CODE,
					   AVG(f.AVG_RATE) as AVG_RATE
				FROM (SELECT SUBSTRING(CONVERT(nvarchar(10), k.KURS_DATE, 23), 6, 5) as PART_MONTH_DATE,
							 k.CURRENCY_CODE,
							 (k.RATE/a.AVG_RATE)*100 as AVG_RATE
					  FROM KURS k
					  INNER JOIN KURS_AVG_YEAR a ON a.PART_YEAR = CONVERT(nvarchar(4), DATEPART(year,k.KURS_DATE)) AND a.CURRENCY_CODE = k.CURRENCY_CODE
                      ) f
				GROUP BY f.PART_MONTH_DATE, f.CURRENCY_CODE
),
KURS_AVG_YEAR_MAX (PART_YEAR) AS
(
  SELECT CONVERT(nvarchar(4), MAX(DATEPART(year,kk.KURS_DATE))) AS PART_YEAR
  FROM KURS kk
)
 SELECT k.KURS_DATE,
		k.CURRENCY_CODE,
		k.RATE,
		a.AVG_RATE as AVG_RATE
FROM KURS k
INNER JOIN KURS_AVG a ON a.CURRENCY_CODE = k.CURRENCY_CODE AND a.PART_MONTH_DATE = SUBSTRING(CONVERT(nvarchar(10), k.KURS_DATE, 23), 6, 5) AND a.AVG_RATE <= 100
INNER JOIN KURS_AVG_YEAR_MAX y ON y.PART_YEAR = CONVERT(nvarchar(4), DATEPART(year,k.KURS_DATE))
WHERE k.CURRENCY_CODE = '840'
GO
/****** Object:  Table [dbo].[BUFF_IMPORT_DATA]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BUFF_IMPORT_DATA](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DATA_TYPE] [nvarchar](255) NOT NULL,
	[DATA_VALUE] [nvarchar](max) NULL,
	[SYS_DATE] [datetime2](7) NOT NULL,
	[IS_ERROR] [nvarchar](1) NULL,
	[ERROR_MESSAGE] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KURS_HIST]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KURS_HIST](
	[Id] [int] NOT NULL,
	[CURRENCY_CODE] [nvarchar](3) NULL,
	[KURS_DATE] [date] NULL,
	[RATE] [money] NULL,
	[FORC] [int] NULL,
	[SYS_DATE] [datetime2](7) NULL,
	[SUSER_NAME] [nvarchar](max) NULL,
	[HOST_NAME] [nvarchar](max) NULL,
	[ACTION] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KURS_SSIS]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KURS_SSIS](
	[ID] [int] NULL,
	[ID_EXT] [int] NOT NULL,
	[SUBSYSTEM_CODE] [nvarchar](255) NOT NULL,
	[CURRENCY_CODE] [nvarchar](3) NULL,
	[KURS_DATE] [date] NULL,
	[RATE] [money] NULL,
	[FORC] [int] NULL,
	[SYS_DATE] [datetime2](7) NOT NULL,
	[EVENT_CODE] [nvarchar](1) NULL,
	[ERROR_CODE] [int] NULL,
	[ERROR_MESSAGE] [nvarchar](max) NULL,
	[HASH_COLIMN]  AS (CONVERT([varbinary](64),hashbytes('SHA2_512',concat([ID_EXT],'|',[SUBSYSTEM_CODE])))) PERSISTED
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_CURRENCY_CODE]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_CURRENCY_CODE] ON [dbo].[CURRENCY]
(
	[CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [I_FAIR_VALUE_ISIN]    Script Date: 06.11.2022 22:30:23 ******/
CREATE NONCLUSTERED INDEX [I_FAIR_VALUE_ISIN] ON [dbo].[FAIR_VALUE]
(
	[ISIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_FAIR_VALUE]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_FAIR_VALUE] ON [dbo].[FAIR_VALUE]
(
	[CALC_DATE] ASC,
	[ISIN] ASC,
	[CURRENCY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_ISIN_SECUR]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_ISIN_SECUR] ON [dbo].[ISIN_SECUR]
(
	[ISIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UK_ISIN_SECUR_PAY]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_ISIN_SECUR_PAY] ON [dbo].[ISIN_SECUR_PAY]
(
	[ISIN_SECUR_ID] ASC,
	[PAY_DATE] ASC,
	[PAY_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [I_KURS_CURR_CODE_AND_DATE]    Script Date: 06.11.2022 22:30:23 ******/
CREATE NONCLUSTERED INDEX [I_KURS_CURR_CODE_AND_DATE] ON [dbo].[KURS]
(
	[CURRENCY_CODE] ASC,
	[KURS_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_KURS_SSIS]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_KURS_SSIS] ON [dbo].[KURS_SSIS]
(
	[ID_EXT] ASC,
	[SUBSYSTEM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [UK_KURS_SSIS_HASH]    Script Date: 06.11.2022 22:30:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_KURS_SSIS_HASH] ON [dbo].[KURS_SSIS]
(
	[HASH_COLIMN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BUFF_IMPORT_DATA] ADD  DEFAULT (sysdatetime()) FOR [SYS_DATE]
GO
ALTER TABLE [dbo].[KURS] ADD  DEFAULT (NEXT VALUE FOR [dbo].[SEQ_KURS]) FOR [Id]
GO
ALTER TABLE [dbo].[KURS] ADD  DEFAULT (sysdatetime()) FOR [SYS_DATE]
GO
ALTER TABLE [dbo].[KURS_HIST] ADD  DEFAULT (NEXT VALUE FOR [dbo].[SEQ_KURS_HIST]) FOR [Id]
GO
ALTER TABLE [dbo].[KURS_HIST] ADD  DEFAULT (sysdatetime()) FOR [SYS_DATE]
GO
ALTER TABLE [dbo].[KURS_HIST] ADD  DEFAULT (suser_sname()) FOR [SUSER_NAME]
GO
ALTER TABLE [dbo].[KURS_HIST] ADD  DEFAULT (host_name()) FOR [HOST_NAME]
GO
ALTER TABLE [dbo].[KURS_SSIS] ADD  DEFAULT (NEXT VALUE FOR [dbo].[SEQ_KURS_SSIS_ID_EXT]) FOR [ID_EXT]
GO
ALTER TABLE [dbo].[KURS_SSIS] ADD  DEFAULT (sysdatetime()) FOR [SYS_DATE]
GO
ALTER TABLE [dbo].[ISIN_SECUR_PAY]  WITH CHECK ADD  CONSTRAINT [FK_ISIN_SECUR_PAY] FOREIGN KEY([ISIN_SECUR_ID])
REFERENCES [dbo].[ISIN_SECUR] ([ID])
GO
ALTER TABLE [dbo].[ISIN_SECUR_PAY] CHECK CONSTRAINT [FK_ISIN_SECUR_PAY]
GO
ALTER TABLE [dbo].[KURS]  WITH CHECK ADD  CONSTRAINT [FK_KURS_CURRENCY_CODE] FOREIGN KEY([CURRENCY_CODE])
REFERENCES [dbo].[CURRENCY] ([CODE])
GO
ALTER TABLE [dbo].[KURS] CHECK CONSTRAINT [FK_KURS_CURRENCY_CODE]
GO
ALTER TABLE [dbo].[KURS]  WITH CHECK ADD  CONSTRAINT [CK_KURS_FORC] CHECK  (([FORC]>(0)))
GO
ALTER TABLE [dbo].[KURS] CHECK CONSTRAINT [CK_KURS_FORC]
GO
ALTER TABLE [dbo].[KURS]  WITH CHECK ADD  CONSTRAINT [CK_KURS_RATE] CHECK  (([RATE]>(0)))
GO
ALTER TABLE [dbo].[KURS] CHECK CONSTRAINT [CK_KURS_RATE]
GO
/****** Object:  StoredProcedure [dbo].[add_kurs_nbu_ssis]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_kurs_nbu_ssis]
AS
   DECLARE @m_CURRENCY_CODE nvarchar(3), @m_CURRENCY_CODE_EXT nvarchar(3), @m_KURS_DATE date, @m_RATE money, @m_FORC int, @m_HASH_COLIMN VARBINARY(64), @m_Id int
   DECLARE @m_error_message nvarchar(255)
   DECLARE @tbl TABLE (ID int)

   DECLARE my_cur CURSOR FOR 
     SELECT cur.CODE AS CURRENCY_CODE, t.CURRENCY_CODE, t.KURS_DATE, t.RATE, t.FORC, t.HASH_COLIMN
     FROM KURS_SSIS t  
	 LEFT OUTER JOIN CURRENCY cur on (t.CURRENCY_CODE = cur.SHORT_NAME)     
     WHERE t.ID is null    
BEGIN
    -- Загрузка с внешнего сервиса SSIS курсов с записью в таблицу
    OPEN my_cur
    FETCH NEXT FROM my_cur INTO @m_CURRENCY_CODE, @m_CURRENCY_CODE_EXT, @m_KURS_DATE, @m_RATE, @m_FORC, @m_HASH_COLIMN
   
    WHILE @@FETCH_STATUS = 0 -- пока не закончатся строки в курсоре
    BEGIN
      BEGIN TRANSACTION      
      BEGIN TRY        
        IF @m_CURRENCY_CODE IS NULL
          BEGIN
            SET @m_error_message = CONCAT('Не найден код валюты CURRENCY.CODE = ', @m_CURRENCY_CODE_EXT);
            THROW 51000, @m_error_message, 1;
          END

        SELECT @m_Id = MAX(k.Id)
        FROM KURS k
        WHERE k.CURRENCY_CODE = @m_CURRENCY_CODE and k.KURS_DATE = @m_KURS_DATE;	            

        IF @m_Id IS NULL        
           BEGIN
              INSERT INTO KURS (CURRENCY_CODE, KURS_DATE, RATE, FORC)   
              OUTPUT inserted.Id INTO @tbl
                 VALUES (@m_CURRENCY_CODE, @m_KURS_DATE, @m_RATE, @m_FORC);
              
              SELECT @m_Id = ID FROM @tbl; -- так как IDENT_CURRENT('KURS'); возвращает пустоту

              UPDATE KURS_SSIS
              SET ID = @m_Id,
                  EVENT_CODE = 'I', 
                  ERROR_CODE = 0, 
                  ERROR_MESSAGE = NULL
              WHERE HASH_COLIMN = @m_HASH_COLIMN; 
           END
        ELSE
              UPDATE KURS_SSIS
              SET ID = @m_Id,
                  EVENT_CODE = 'U', 
                  ERROR_CODE = 0,
                  ERROR_MESSAGE = NULL
              WHERE HASH_COLIMN = @m_HASH_COLIMN;        
        
        COMMIT TRANSACTION;
      END TRY
      BEGIN CATCH
        ROLLBACK TRANSACTION; 

        UPDATE KURS_SSIS
        SET ERROR_CODE = ERROR_NUMBER(), 
            ERROR_MESSAGE = ERROR_MESSAGE()
        WHERE HASH_COLIMN = @m_HASH_COLIMN;        
      END CATCH

      --считываем следующую строку курсора
      FETCH NEXT FROM my_cur INTO @m_CURRENCY_CODE, @m_CURRENCY_CODE_EXT, @m_KURS_DATE, @m_RATE, @m_FORC, @m_HASH_COLIMN
    END
   
    CLOSE my_cur
    DEALLOCATE my_cur
    
END
GO
/****** Object:  StoredProcedure [dbo].[date_to_str]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[date_to_str]
	@p_date   DATE, 
	@p_format NVARCHAR(100) = 'dd.mm.yyyy',
	@p_rezult NVARCHAR(30) OUTPUT
AS
BEGIN
	-- Преобразование даты в текст
	DECLARE @m_format INT;

	IF (@p_date is null or @p_date = '') 
	    RETURN null;

	-- T-SQL syntax
	SET @m_format = CASE @p_format   
					WHEN 'mm/dd/yy' THEN 1     
					WHEN 'yy.mm.dd' THEN 2     
					WHEN 'dd/mm/yy' THEN 3     
					WHEN 'dd.mm.yy' THEN 4     
					WHEN 'dd-mm-yy' THEN 5     
					WHEN 'dd-Mon-yy' THEN 6     
					WHEN 'Mon dd, yy' THEN 7     
					WHEN 'mm-dd-yy' THEN 10     
					WHEN 'yy/mm/dd' THEN 11     
					WHEN 'yymmdd' THEN 12     
					WHEN 'yyyy-mm-dd' THEN 23
					WHEN 'mm/dd/yyyy' THEN 101     
					WHEN 'yyyy.mm.dd' THEN 102     
					WHEN 'dd/mm/yyyy' THEN 103     
					WHEN 'dd.mm.yyyy' THEN 104     
					WHEN 'dd-mm-yyyy' THEN 105     
					WHEN 'dd Mon yyyy' THEN 106     
					WHEN 'Mon dd, yyyy' THEN 107     
					WHEN 'mm-dd-yyyy' THEN 110
					WHEN 'yyyy/mm/dd' THEN 111
					WHEN 'yyyymmdd' THEN 112
					ELSE 0
					END   	 

	IF @m_format = 0
		RAISERROR('Не найден формат для преобразования = %s', 1, 2, @p_format) WITH SETERROR;
		
	IF TRY_CONVERT(NVARCHAR(30), @p_date, @m_format) is null	  
	   RAISERROR('Невозможно преобразовать дату в текст', 1, 2) WITH SETERROR;
	
	SET @p_rezult = CONVERT(NVARCHAR(30), @p_date, @m_format);    
END
GO
/****** Object:  StoredProcedure [dbo].[exec_add_fair_value]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_add_fair_value]
	@p_id int
AS
BEGIN
  DECLARE @m_error_message NVARCHAR(MAX);   

  BEGIN TRY 
    -- Загрузка с внешнего сервиса Справедливая стоимость ЦБ (котировки НБУ) с записью в таблицу
	-- Получение данных
    CREATE TABLE #tmp (RowNumber INT, 		   
		               calc_date DATE,
		               cpcode NVARCHAR(30) Collate Cyrillic_General_CI_AS,
		               ccy NVARCHAR(3) Collate Cyrillic_General_CI_AS,
   		               fair_value NUMERIC(38,16),
		               ytm NUMERIC(38,16),
		               clean_rate NUMERIC(38,16),
		               cor_coef NUMERIC(38,16),
		               maturity DATE,
		               cor_coef_cash NUMERIC(38,16),
					   cor_coef_swap NUMERIC(38,16),
		               notional NUMERIC(38,16),
		               avr_rate NUMERIC(38,16),
		               option_value NUMERIC(38,16),
		               intrinsic_value NUMERIC(38,16),
		               time_value NUMERIC(38,16),
		               delta_per NUMERIC(38,16),
		               delta_equ NUMERIC(38,16),
				       gs_zs_cptype NVARCHAR(255) Collate Cyrillic_General_CI_AS
                      );
   
    INSERT INTO #tmp
	EXECUTE [dbo].[exec_read_fair_value]
		@p_id = @p_id;

    -- Обновление таблицы
    MERGE FAIR_VALUE AS target
    USING (SELECT t.calc_date, 
   				  t.cpcode, 
				  cur.CODE, 
				  t.fair_value, 
				  t.ytm, 
				  t.clean_rate, 
				  t.cor_coef, 
				  t.maturity, 
			  	  t.cor_coef_cash, 
				  t.cor_coef_swap,
				  t.notional, 
				  t.avr_rate, 
				  t.option_value, 
				  t.intrinsic_value, 
				  t.time_value, 
				  t.delta_per, 
				  t.delta_equ,
				  t.gs_zs_cptype
           FROM #tmp t
		   INNER JOIN CURRENCY cur ON cur.SHORT_NAME = t.ccy
          ) AS source ( calc_date, 
   					    isin, 
						currency_code, 
						fair_value, 
						ytm, 
						clean_rate, 
						cor_coef, 
						maturity, 
						cor_coef_cash, 
						cor_coef_swap,
						notional, 
						avr_rate, 
						option_value, 
						intrinsic_value, 
						time_value, 
						delta_per, 
						delta_equ, 
						gs_zs_cptype
                      )
    ON (target.CALC_DATE = source.calc_date AND target.ISIN = source.isin AND target.CURRENCY_CODE = source.currency_code)
    
    WHEN NOT MATCHED
        THEN INSERT(CALC_DATE, 
   					ISIN, 
					CURRENCY_CODE, 
					FAIR_VALUE, 
					YTM, 
					CLEAN_RATE, 
					COR_COEF, 
					MATURITY, 
					COR_COEF_CASH, 
					COR_COEF_SWAP,
					NOTIONAL, 
					AVR_RATE, 
					OPTION_VALUE, 
					INTRINSIC_VALUE, 
					TIME_VALUE, 
					DELTA_PER, 
					DELTA_EQU,
					GS_ZS_CPTYPE
				   ) 
		     VALUES (
		            source.calc_date,
		            source.isin,
		            source.currency_code,
   		            source.fair_value,
		            source.ytm,
		            source.clean_rate,
		            source.cor_coef,
		            source.maturity,
		            source.cor_coef_cash,
					source.cor_coef_swap,
		            source.notional,
		            source.avr_rate,
		            source.option_value,
		            source.intrinsic_value,
		            source.time_value,
		            source.delta_per,
		            source.delta_equ,
					source.gs_zs_cptype		            
					) -- вставка
    ;
   -- удаляем временную таблицу 
   drop table #tmp;
   -- обновляем статус
   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'F', ERROR_MESSAGE = null
   WHERE ID = @p_id;
 
 END TRY  
 BEGIN CATCH  
   -- обновляем статус
   EXECUTE [dbo].[get_error_info] @rezult = @m_error_message;

   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'T', ERROR_MESSAGE = @m_error_message
   WHERE ID = @p_id;
 END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[exec_add_isin_secur]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_add_isin_secur]
		@p_id int
AS
BEGIN
  DECLARE @m_error_message NVARCHAR(MAX);   

  BEGIN TRY 
    -- Загрузка с внешнего сервиса Перечень ISIN ЦБ с купонными периодами с записью в таблицу
	-- Получение данных
    CREATE TABLE #tmp (cpcode        NVARCHAR(255) Collate Cyrillic_General_CI_AS,
                       nominal       NUMERIC,
	                   auk_proc      NUMERIC,
	                   pgs_date      DATE,
	                   razm_date     DATE,
	                   cptype        NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   cpdescr       NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   pay_period    NUMERIC,
	                   val_code      NVARCHAR(3) Collate Cyrillic_General_CI_AS,
	                   emit_okpo     NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   emit_name     NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   cptype_nkcpfr NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   cpcode_cfi    NVARCHAR(255) Collate Cyrillic_General_CI_AS,
	                   total_bonds   NUMERIC,
	                   pay_date      DATE,
	                   pay_type      NUMERIC,
	                   pay_val       NUMERIC,
	                   pay_array     NVARCHAR(5) Collate Cyrillic_General_CI_AS
                      );
   
    INSERT INTO #tmp
	EXECUTE [dbo].[exec_read_isin_secur]
		@p_id = @p_id;

    ------------------------------------------------------------
    -- Обновление таблицы ISIN_SECUR
    ------------------------------------------------------------
    MERGE ISIN_SECUR AS target
    USING (SELECT DISTINCT 
	              t.cpcode,
                  t.nominal,
	              t.auk_proc,
	              t.pgs_date,
	              t.razm_date,
	              t.cptype,
	              t.cpdescr,
	              t.pay_period,
	              cur.CODE,
	              t.emit_okpo,
	              t.emit_name,
	              t.cptype_nkcpfr,
	              t.cpcode_cfi,
	              t.total_bonds
           FROM #tmp t
		   INNER JOIN CURRENCY cur ON cur.SHORT_NAME = t.val_code
          ) AS source ( isin,
                        nominal,
	                    auk_proc,
	                    pgs_date,
	                    razm_date,
	                    cptype,
	                    cpdescr,
	                    pay_period,
						currency_code,	              
	                    emit_okpo,
	                    emit_name,
	                    cptype_nkcpfr,
	                    cpcode_cfi,
	                    total_bonds
                      )
    ON (target.ISIN = source.isin)
    
    WHEN NOT MATCHED
        THEN INSERT(ISIN,
                    NOMINAL,
	                AUK_PROC,
	                PGS_DATE,
	                RAZM_DATE,
	                CPTYPE,
	                CPDESCR,
	                PAY_PERIOD,
					CURRENCY_CODE,	              
	                EMIT_OKPO,
	                EMIT_NAME,
	                CPTYPE_NKCPFR,
	                CPCODE_CFI,
	                TOTAL_BONDS
				   ) 
		     VALUES (
			        source.isin,
                    source.nominal,
	                source.auk_proc,
	                source.pgs_date,
	                source.razm_date,
	                source.cptype,
	                source.cpdescr,
	                source.pay_period,
					source.currency_code,	              
	                source.emit_okpo,
	                source.emit_name,
	                source.cptype_nkcpfr,
	                source.cpcode_cfi,
	                source.total_bonds
					) -- вставка
    ;

	------------------------------------------------------------
    -- Обновление таблицы ISIN_SECUR_PAY
    ------------------------------------------------------------
    MERGE ISIN_SECUR_PAY AS target
    USING (SELECT sec.ID as isin_secur_id,
				  t.pay_date,
	              t.pay_type,
	              t.pay_val
           FROM #tmp t
		   INNER JOIN ISIN_SECUR sec ON sec.ISIN = t.cpcode
          ) AS source ( isin_secur_id,
	                    pay_date,
	                    pay_type,
	                    pay_val
                      )
    ON (target.ISIN_SECUR_ID = source.isin_secur_id AND target.PAY_DATE = source.pay_date AND target.PAY_TYPE = source.pay_type)
    
    WHEN NOT MATCHED
        THEN INSERT(ISIN_SECUR_ID,
                    PAY_DATE,
	                PAY_TYPE,
	                PAY_VAL
				   ) 
		     VALUES (
			        source.isin_secur_id,
	                source.pay_date,
	                source.pay_type,
	                source.pay_val
					) -- вставка
    ;

   -- удаляем временную таблицу 
   drop table #tmp;

   -- обновляем статус
   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'F', ERROR_MESSAGE = null
   WHERE ID = @p_id;
 
 END TRY  
 BEGIN CATCH  
   -- обновляем статус
   EXECUTE [dbo].[get_error_info] @rezult = @m_error_message;

   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'T', ERROR_MESSAGE = @m_error_message
   WHERE ID = @p_id;
 END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[exec_add_kurs_nbu]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_add_kurs_nbu]
	@p_id int	
AS
BEGIN
  DECLARE @m_error_message NVARCHAR(MAX);   

  BEGIN TRY 
    -- Загрузка с внешнего сервиса курсов с записью в таблицу
	-- Получение данных
    CREATE TABLE #tmp (r030 NVARCHAR(MAX) Collate Cyrillic_General_CI_AS, 
                       txt  NVARCHAR(MAX) Collate Cyrillic_General_CI_AS,
                       rate MONEY,
                       cc   NVARCHAR(MAX) Collate Cyrillic_General_CI_AS,
                       exchangedate DATE);
   
    INSERT INTO #tmp
	EXECUTE [dbo].[exec_read_kurs_nbu]
		@p_id = @p_id;

    -- Обновление таблицы списков валют
    MERGE CURRENCY AS target
    USING (SELECT t.r030, t.txt, t.cc
           FROM #tmp t
          ) AS source (r030, txt, cc)
    ON (target.CODE = source.r030)

    WHEN MATCHED AND target.NAME IS NOT NULL
        THEN UPDATE SET target.NAME = source.txt -- обновление

    WHEN NOT MATCHED
        THEN INSERT (CODE, NAME, SHORT_NAME) VALUES(source.r030, source.txt, source.cc) -- вставка
    ;
    --OUTPUT $action, inserted.*, deleted.*; -- можно вывести измененные строки

    -- Обновление таблицы курсов валют
    MERGE KURS AS target
    USING (SELECT t.r030, t.rate, 1 as forc, t.exchangedate
           FROM #tmp t
          ) AS source (r030, rate, forc, exchangedate)
    ON (target.CURRENCY_CODE = source.r030 AND target.KURS_DATE = source.exchangedate)
    
    WHEN NOT MATCHED
        THEN INSERT (CURRENCY_CODE, KURS_DATE, RATE, FORC) VALUES(source.r030, source.exchangedate, source.rate, source.forc) -- вставка
    ;
   -- удаляем временную таблицу 
   drop table #tmp;

   -- обновляем статус
   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'F', ERROR_MESSAGE = null
   WHERE ID = @p_id;
 
 END TRY  
 BEGIN CATCH  
   -- обновляем статус
   EXECUTE [dbo].[get_error_info] @rezult = @m_error_message;

   UPDATE BUFF_IMPORT_DATA
   SET IS_ERROR = 'T', ERROR_MESSAGE = @m_error_message
   WHERE ID = @p_id;
 END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[exec_read_fair_value]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_read_fair_value]
	@p_id int
AS
BEGIN
   -- Справедливая стоимость ЦБ (котировки НБУ) (разворачивание из таблицы BUFF_IMPORT_DATA)
   DECLARE @p_data_type     NVARCHAR(255) = 'FairValue';   
   DECLARE @p_response_body NVARCHAR(MAX);      

   SET NOCOUNT ON;
   SELECT @p_response_body = b.DATA_VALUE
   FROM BUFF_IMPORT_DATA b
   WHERE b.ID = @p_id and b.DATA_TYPE =  @p_data_type and b.IS_ERROR is null;	 
    
	-- возвращаем значение
	SET NOCOUNT ON;
	SELECT f.*
	FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY (select null)) AS RowNumber, 		   
			[dbo].[str_to_date_func]([dbo].[split_part] (t.value, default, 1), default) as calc_date,
			[dbo].[split_part] (t.value, default, 2) as cpcode,
			[dbo].[split_part] (t.value, default, 3) as ccy,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 4)) as fair_value,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 5)) as ytm,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 6)) as clean_rate,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 7)) as cor_coef,	   
			[dbo].[str_to_date_func]([dbo].[split_part] (t.value, default, 8), default) as maturity,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 9)) as cor_coef_cash,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 10)) as cor_coef_swap,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 11)) as notional,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 12)) as avr_rate,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 13)) as option_value,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 14)) as intrinsic_value,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 15)) as time_value,
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 16)) as delta_per,	   
			[dbo].[str_to_num_func]([dbo].[split_part] (t.value, default, 17)) as delta_equ,
			[dbo].[split_part] (t.value, default, 18) as gs_zs_cptype
		FROM STRING_SPLIT(@p_response_body, char(13)) as t
		) f
	WHERE f.RowNumber > 1 and f.calc_date is not null
END
GO
/****** Object:  StoredProcedure [dbo].[exec_read_isin_secur]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_read_isin_secur]
	@p_id int
AS
BEGIN
   -- Перечень ISIN ЦБ с купонными периодами (разворачивание из таблицы BUFF_IMPORT_DATA)
   DECLARE @p_data_type     NVARCHAR(255) = 'IsinSecur';   
   DECLARE @p_response_body NVARCHAR(MAX);   
   DECLARE @p_XML			XML;
   DECLARE @p_read_isin_secur AS TABLE (cpcode        NVARCHAR(255),
	                                    nominal       NUMERIC,
	                                    auk_proc      NUMERIC,
	                                    pgs_date      DATE,
	                                    razm_date     DATE,
	                                    cptype        NVARCHAR(255),
	                                    cpdescr       NVARCHAR(255),
	                                    pay_period    NUMERIC,
	                                    val_code      NVARCHAR(3),
	                                    emit_okpo     NVARCHAR(255),
	                                    emit_name     NVARCHAR(255),
	                                    cptype_nkcpfr NVARCHAR(255),
	                                    cpcode_cfi    NVARCHAR(255),
	                                    total_bonds   NUMERIC,
	                                    pay_date      DATE,
	                                    pay_type      NUMERIC,
	                                    pay_val       NUMERIC,
	                                    pay_array     NVARCHAR(5)
                                        );

   SET NOCOUNT ON;
   SELECT @p_response_body = b.DATA_VALUE
   FROM BUFF_IMPORT_DATA b
   WHERE b.ID = @p_id and b.DATA_TYPE =  @p_data_type and b.IS_ERROR is null;	 
      
   -- JSON формат
   IF (SELECT [dbo].[is_valid_json] (@p_response_body)) = 'T'
      BEGIN	
            SELECT t.cpcode,
				   t.nominal,
                   [dbo].[str_to_num_func](t.auk_proc) as auk_proc,
                   [dbo].[str_to_date_func] (t.pgs_date,'yyyy.mm.dd') as pgs_date,
                   [dbo].[str_to_date_func] (t.razm_date,'yyyy.mm.dd') as razm_date,
				   t.cptype as cptype,
                   t.cpdescr as cpdescr,
                   t.pay_period as pay_period,
                   t.val_code as val_code,
                   t.emit_okpo as emit_okpo,
                   t.emit_name as emit_name,
                   t.cptype_nkcpfr as cptype_nkcpfr,
                   t.cpcode_cfi as cpcode_cfi,
                   t.total_bonds as total_bonds,
                   ---------------------------------------------------------
                   [dbo].[str_to_date_func] (y.pay_date,'yyyy.mm.dd') as pay_date,
                   y.pay_type as pay_type,
                   [dbo].[str_to_num_func](y.pay_val) as pay_val,
	               y.pay_array as pay_array
              INTO #temp_table_read_isin_secur_json     
              FROM OPENJSON(@p_response_body)
              WITH (cpcode    NVARCHAR(255) '$.cpcode',
                    nominal   NUMERIC '$.nominal',
                    auk_proc  NVARCHAR(255) '$.auk_proc',
                    pgs_date  NVARCHAR(255) '$.pgs_date',
                    razm_date NVARCHAR(255) '$.razm_date',
                    cptype    NVARCHAR(255) '$.cptype',
                    cpdescr   NVARCHAR(255) '$.cpdescr',
                    pay_period NUMERIC      '$.pay_period',
                    val_code  NVARCHAR(3)   '$.val_code',
                    emit_okpo NVARCHAR(255) '$.emit_okpo',
                    emit_name NVARCHAR(255) '$.emit_name',
                    cptype_nkcpfr NVARCHAR(255) '$.cptype_nkcpfr',
                    cpcode_cfi NVARCHAR(255) '$.cpcode_cfi',                                                
	                total_bonds NVARCHAR(255) '$.pay_period',
                    [payments] NVARCHAR(MAX) AS JSON
                    ) as t
               CROSS APPLY OPENJSON(t.payments, '$')
               WITH (pay_date   NVARCHAR(255) '$.pay_date',
                     pay_type   NUMERIC       '$.pay_type',
                     pay_val    NVARCHAR(255) '$.pay_val',
                     pay_array  NVARCHAR(255) '$.array'
                     ) as y

          -- наполняем данными из временной таблицы
          INSERT INTO @p_read_isin_secur
               SELECT * FROM #temp_table_read_isin_secur_json t
               
          -- удаляем временную таблицу 
          drop table #temp_table_read_isin_secur_json

	  END
   
   -- XML формат   
   IF (SELECT [dbo].[is_valid_xml] (@p_response_body)) = 'T'
      BEGIN
	    SET @p_XML = CAST([dbo].[str_xml_format](@p_response_body) AS XML);		  	

            SELECT x.n.value('cpcode[1]','nvarchar(255)') as cpcode,
				   x.n.value('nominal[1]','numeric') as nominal,
                   [dbo].[str_to_num_func](x.n.value('auk_proc[1]','nvarchar(255)')) as auk_proc,
                   [dbo].[str_to_date_func] (x.n.value('pgs_date[1]','nvarchar(255)'),'yyyy.mm.dd') as pgs_date,
                   [dbo].[str_to_date_func] (x.n.value('razm_date[1]','nvarchar(255)'),'yyyy.mm.dd') as razm_date,
				   x.n.value('cptype[1]','nvarchar(255)') as cptype,
                   x.n.value('cpdescr[1]','nvarchar(255)') as cpdescr,
                   x.n.value('pay_period[1]','numeric') as pay_period,
                   x.n.value('val_code[1]','nvarchar(3)') as val_code,
                   x.n.value('emit_okpo[1]','nvarchar(255)') as emit_okpo,
                   x.n.value('emit_name[1]','nvarchar(255)') as emit_name,
                   x.n.value('cptype_nkcpfr[1]','nvarchar(255)') as cptype_nkcpfr,
                   x.n.value('cpcode_cfi[1]','nvarchar(255)') as cpcode_cfi,
                   x.n.value('pay_period[1]','numeric') as total_bonds,
                   ---------------------------------------------------------
                   [dbo].[str_to_date_func] (y.n.value('pay_date[1]','nvarchar(255)'),'yyyy.mm.dd') as pay_date,
                   y.n.value('pay_type[1]','numeric') as pay_type,
                   [dbo].[str_to_num_func](y.n.value('pay_val[1]','nvarchar(255)')) as pay_val,
	               y.n.value('array[1]','nvarchar(5)') as pay_array
              INTO #temp_table_read_isin_secur_xml     
              FROM @p_XML.nodes('securities/security/.') x(n)
              CROSS APPLY x.n.nodes('payments/payment/.') y(n)

          -- наполняем данными из временной таблицы
          INSERT INTO @p_read_isin_secur
               SELECT * FROM #temp_table_read_isin_secur_xml t
               
          -- удаляем временную таблицу 
          drop table #temp_table_read_isin_secur_xml
	  END

   -- возвращаем значение
   SET NOCOUNT ON;
   SELECT * FROM @p_read_isin_secur
END
GO
/****** Object:  StoredProcedure [dbo].[exec_read_kurs_nbu]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[exec_read_kurs_nbu]
	@p_id int
AS
BEGIN
   -- Курсы валют НБУ (разворачивание из таблицы BUFF_IMPORT_DATA)
   DECLARE @p_data_type     NVARCHAR(255) = 'KursIn';
   DECLARE @p_response_body NVARCHAR(MAX);   
   DECLARE @p_XML			XML;
   DECLARE @p_read_kurs_nbu AS [dbo].[t_read_kurs_nbu];

   SET NOCOUNT ON;
   SELECT @p_response_body = b.DATA_VALUE
   FROM BUFF_IMPORT_DATA b
   WHERE b.ID = @p_id and b.DATA_TYPE =  @p_data_type and b.IS_ERROR is null;	 
      
   -- JSON формат
   IF (SELECT [dbo].[is_valid_json] (@p_response_body)) = 'T'
      BEGIN		
		   INSERT INTO @p_read_kurs_nbu (r030, txt, rate, cc, exchangedate)
		        SELECT [dbo].[lpad] (t.r030,3,'0') as r030,
                        t.txt,
                        [dbo].[str_to_num_func] (t.rate) as rate,
                        t.cc,
                        [dbo].[str_to_date_func] (t.exchangedate, default) as exchangedate
                FROM OPENJSON(@p_response_body)
                WITH (r030 NVARCHAR(3) '$.r030',
                        txt  NVARCHAR(255) '$.txt',
                        rate NVARCHAR(255) '$.rate',
                        cc   NVARCHAR(255) '$.cc',
                        exchangedate NVARCHAR(255) '$.exchangedate') as t
	  END
   
   -- XML формат   
   IF (SELECT [dbo].[is_valid_xml] (@p_response_body)) = 'T'
      BEGIN
	    SET @p_XML = CAST([dbo].[str_xml_format](@p_response_body) AS XML);		  	

		   INSERT INTO @p_read_kurs_nbu (r030, txt, rate, cc, exchangedate)
            SELECT [dbo].[lpad](x.n.value('r030[1]','nvarchar(3)'),3,'0') as r030,
				   x.n.value('txt[1]','nvarchar(255)') as txt,
				   [dbo].[str_to_num_func](x.n.value('rate[1]','nvarchar(255)')) as rate,
				   x.n.value('cc[1]','nvarchar(255)') as cc,
				   [dbo].[str_to_date_func] (x.n.value('exchangedate[1]','nvarchar(255)'), default) as exchangedate
              FROM @p_XML.nodes('exchange/currency/.') x(n)		
	  END

   -- возвращаем значение
   SET NOCOUNT ON;
   SELECT * FROM @p_read_kurs_nbu
END
GO
/****** Object:  StoredProcedure [dbo].[get_error_info]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_error_info]
   @rezult NVARCHAR(MAX) OUTPUT
AS
BEGIN
  -- Описание ошибки
 SELECT TOP 1 @rezult = 
    'ErrorNumber:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_NUMBER()),'') + ' ' + 
    'ErrorSeverity:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_SEVERITY()),'') + ' ' + 
    'ErrorState:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_STATE()),'') + ' ' + 
    'ErrorProcedure:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_PROCEDURE()),'') + ' ' + 
    'ErrorLine:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_LINE()),'') + ' ' + 
    'ErrorMessage:' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_MESSAGE()),'');
END
GO
/****** Object:  StoredProcedure [dbo].[insert_kurs]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_kurs]
	@p_curs_date NVARCHAR(255),
	@p_curr_code NVARCHAR(3),
	@p_rate NUMERIC(38,6)
AS
  DECLARE @m_curr_code NVARCHAR(3);
BEGIN
   SELECT @m_curr_code = c.CODE FROM CURRENCY c WHERE c.SHORT_NAME = @p_curr_code;

   INSERT INTO KURS (KURS_DATE, CURRENCY_CODE, RATE, FORC)
       SELECT CONVERT(date, @p_curs_date, 23), @m_curr_code, @p_rate, 1
       WHERE NOT EXISTS (SELECT 1 FROM KURS c where c.KURS_DATE = CONVERT(date, @p_curs_date, 23) and c.CURRENCY_CODE = @m_curr_code);     
RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[proc_fair_report]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_fair_report]	
	@calc_date date,
	@isin nvarchar(255) = ''
AS
  -- Отчет о ЦБ и их справедливой стоимости
	WITH FAIR_VALUE_LIST (ISIN, LAST_CALC_DATE, LAST_FAIR_VALUE) AS
	(
		SELECT ff.ISIN,
			   MAX(ff.LAST_CALC_DATE) as LAST_CALC_DATE,
			   MAX(ff.LAST_FAIR_VALUE) as LAST_FAIR_VALUE
		FROM
		(
		 SELECT f.ISIN,
				FIRST_VALUE(f.CALC_DATE) OVER (PARTITION BY f.ISIN ORDER BY f.CALC_DATE DESC ROWS UNBOUNDED PRECEDING) AS LAST_CALC_DATE,
				FIRST_VALUE(f.FAIR_VALUE) OVER (PARTITION BY f.ISIN ORDER BY f.CALC_DATE DESC ROWS UNBOUNDED PRECEDING) AS LAST_FAIR_VALUE
		 FROM FAIR_VALUE f
		 WHERE f.CALC_DATE <= @calc_date AND (ISNULL(@isin,'') = '' or f.ISIN = @isin)
		) ff
		GROUP BY ff.ISIN
	)
	SELECT s.ISIN,
		   s.NOMINAL,
		   s.PAY_PERIOD,
		   s.EMIT_NAME,
		   sp.PAY_DATE,
		   CASE sp.PAY_TYPE
			 WHEN 1 THEN 'Выплата %'
			 WHEN 2 THEN 'Выплата купона'
		   END as PAY_TYPE,
		   sp.PAY_VAL,
		   f.LAST_FAIR_VALUE,
		   f.LAST_CALC_DATE
	FROM ISIN_SECUR s
	LEFT OUTER JOIN ISIN_SECUR_PAY sp on s.ID = sp.ISIN_SECUR_ID AND sp.PAY_DATE >= @calc_date
	LEFT OUTER JOIN FAIR_VALUE_LIST f on s.ISIN = f.ISIN
	WHERE
	   (ISNULL(@isin,'') = '' or s.ISIN = @isin)
	;

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[str_to_date]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[str_to_date]
	@p_text   NVARCHAR(MAX), 
	@p_format NVARCHAR(100) = 'dd.mm.yyyy',
	@p_rezult DATE OUTPUT
AS
BEGIN
	-- Преобразование теста в дату
	DECLARE @m_format INT;

	IF (@p_text is null or @p_text = '') 
	    RETURN null;

	-- T-SQL syntax
	SET @m_format = CASE @p_format   
					WHEN 'mm/dd/yy' THEN 1     
					WHEN 'yy.mm.dd' THEN 2     
					WHEN 'dd/mm/yy' THEN 3     
					WHEN 'dd.mm.yy' THEN 4     
					WHEN 'dd-mm-yy' THEN 5     
					WHEN 'dd-Mon-yy' THEN 6     
					WHEN 'Mon dd, yy' THEN 7     
					WHEN 'mm-dd-yy' THEN 10     
					WHEN 'yy/mm/dd' THEN 11     
					WHEN 'yymmdd' THEN 12     
					WHEN 'yyyy-mm-dd' THEN 23
					WHEN 'mm/dd/yyyy' THEN 101     
					WHEN 'yyyy.mm.dd' THEN 102     
					WHEN 'dd/mm/yyyy' THEN 103     
					WHEN 'dd.mm.yyyy' THEN 104     
					WHEN 'dd-mm-yyyy' THEN 105     
					WHEN 'dd Mon yyyy' THEN 106     
					WHEN 'Mon dd, yyyy' THEN 107     
					WHEN 'mm-dd-yyyy' THEN 110
					WHEN 'yyyy/mm/dd' THEN 111
					WHEN 'yyyymmdd' THEN 112
					ELSE 0
					END   	 

	IF @m_format = 0
		RAISERROR('Не найден формат для преобразования = %s', 1, 2, @p_format) WITH SETERROR;
		
	IF TRY_CONVERT(date, @p_text, @m_format) is null	  
	   RAISERROR('Невозможно преобразовать в дату = %s', 1, 2, @p_text) WITH SETERROR;
	
	SET @p_rezult = CONVERT(date, @p_text, @m_format);    
END
GO
/****** Object:  StoredProcedure [dbo].[str_to_num]    Script Date: 06.11.2022 22:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[str_to_num]
	@p_text NVARCHAR(MAX),
	@p_rezult NUMERIC(38, 15) OUTPUT
AS
  BEGIN
-- Преобразование теста с число
    DECLARE @m_text NVARCHAR(MAX);    

	IF (@p_text is null or @p_text = '') 
	    RETURN null;

    SET @m_text = replace(@p_text,',','.');
    SET @m_text = replace(@p_text,' ','');
    SET @m_text = replace(@p_text,char(13),'');
    SET @m_text = replace(@p_text,char(10),'');
	
    IF TRY_CONVERT(NUMERIC(38, 15), @m_text) is null	  
	   RAISERROR('Невозможно преобразовать в число = %s', 1, 2, @p_text) WITH SETERROR;
	
	SET @p_rezult = CONVERT(NUMERIC(38, 15), @m_text);    
  END
GO
USE [master]
GO
ALTER DATABASE [DatabaseTestDBDocker] SET  READ_WRITE 
GO

/* Добавление кодов валют */
USE [DatabaseTestDBDocker]
GO
BEGIN
    PRINT 'Добавление кодов валют'
    begin transaction;

    PRINT 'UAH-Гривня'
    INSERT INTO [dbo].[CURRENCY] ([CODE] ,[NAME] ,[SHORT_NAME])
    SELECT '980','Гривня','UAH'
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CURRENCY] WHERE CODE = '980');

    PRINT 'USD-Долар США'
    INSERT INTO [dbo].[CURRENCY] ([CODE] ,[NAME] ,[SHORT_NAME])
    SELECT '840','Долар США','USD'
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CURRENCY] WHERE CODE = '840');

    PRINT 'EUR-Євро'
    INSERT INTO [dbo].[CURRENCY] ([CODE] ,[NAME] ,[SHORT_NAME])
    SELECT '978','Євро','EUR'
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CURRENCY] WHERE CODE = '978');

    PRINT 'GBP-Фунт стерлінгів'
    INSERT INTO [dbo].[CURRENCY] ([CODE] ,[NAME] ,[SHORT_NAME])
    SELECT '826','Фунт стерлінгів','GBP'
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CURRENCY] WHERE CODE = '826');

    commit transaction;
END
GO