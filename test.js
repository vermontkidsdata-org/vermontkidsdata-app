metadata = {
  params: ['name', 'age'],
};
for (const param of metadata.params) {
    const paramval = qs?.[param];
    if (paramval == null) {
        return {
        statusCode: 400,
        body: JSON.stringify({ message: `missing parameter ${param}` }),
        };
    } else if (!isAlphanumericWithSpaces(paramval)) {
        return {
        statusCode: 400,
        body: JSON.stringify({ message: `invalid parameter ${param}` }),
        };
    } else {
        const replacename = `\\{\\{${param}\\}\\}`;
        const re = new RegExp(replacename, 'g');
        sqlText = sqlText.replace(re, `'${paramval}'`);
    }
}
