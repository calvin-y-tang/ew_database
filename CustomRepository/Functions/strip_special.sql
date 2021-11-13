Create Function [dbo].[strip_special](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin
    While PatIndex('%[^a-z0-9]%', @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex('%[^a-z0-9]%', @Temp), 1, '')
    Return @TEmp
End