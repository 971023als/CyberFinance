Java.perform(function () {
    // 데이터베이스 쿼리를 실행하는 클래스와 메소드 후킹
    var SQLiteDatabase = Java.use("android.database.sqlite.SQLiteDatabase");
    var rawQuery = SQLiteDatabase.rawQuery.overload('java.lang.String', '[Ljava.lang.String;');

    // rawQuery 메소드 후킹하여 쿼리 내용 로그 기록
    rawQuery.implementation = function (sql, selectionArgs) {
        console.log("실행되는 SQL 쿼리: " + sql);
        if (selectionArgs !== null) {
            console.log("쿼리 파라미터: " + Java.array('java.lang.String', selectionArgs).toString());
        }
        return rawQuery.call(this, sql, selectionArgs);
    };
});
