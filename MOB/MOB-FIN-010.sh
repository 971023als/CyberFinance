Java.perform(function () {
    var accountClass = Java.use("com.example.financial.AccountManager");

    // 이전 비밀번호를 저장하는 임시 데이터 구조 (실제로는 보안 강화가 필요함)
    var oldPasswords = Java.use("java.util.ArrayList").$new();

    // 비밀번호 변경 메소드
    accountClass.changePassword.implementation = function (oldPassword, newPassword) {
        console.log("[알림]: 비밀번호 변경 절차 시작");

        // 이전 비밀번호와 새 비밀번호가 동일한지 확인
        if (oldPassword.equals(newPassword)) {
            console.log("[경고]: 새 비밀번호는 이전 비밀번호와 달라야 합니다.");
            return false;
        }

        // 이전 비밀번호 재사용 확인
        if (oldPasswords.contains(newPassword)) {
            console.log("[경고]: 새 비밀번호는 최근 사용한 비밀번호와 달라야 합니다.");
            return false;
        }

        // 비밀번호 변경 로직
        // 예시: 비밀번호 유효성 검사, 데이터베이스에 비밀번호 업데이트 등
        console.log("[알림]: 비밀번호 변경 중...");
        // ... 비밀번호 변경 로직

        // 새 비밀번호를 이전 비밀번호 목록에 추가
        oldPasswords.add(newPassword);

        console.log("[알림]: 비밀번호가 성공적으로 변경되었습니다.");
        return true;
    };
});
