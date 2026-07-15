# 식물집사 (Plant Parent Care)

> 개인 맞춤형 식물 물주기 일정관리 서비스 — Spring Boot + JSP + MyBatis

## 팀원 설정 가이드

### 1. 클론

```bash
git clone <레포지토리_URL>
cd plantcare
```

### 2. MySQL DB 생성

MySQL 5.7 이상에서 다음 스크립트 실행:

```bash
mysql -u root -p < sql/init.sql
```

→ `plantcare` 데이터베이스, `plantcare` 사용자, 3개 테이블이 생성됨

### 3. 개인 설정 파일 작성

```bash
# application-secret.properties.example을 복사해서 작성
cp src/main/resources/application-secret.properties src/main/resources/application-secret.properties
# (Windows) copy src\main\resources\application-secret.properties src\main\resources\application-secret.properties
```

파일 내용을 본인 환경에 맞게 수정:

```properties
# 농촌진흥청 API 키 (발급: https://api.nongsaro.go.kr)
api.nongsaro.key=발급받은_API_키
```

> ⚠️ `application-secret.properties`는 .gitignore에 등록되어 있어 git에 올라가지 않습니다.

### 4. 실행

```bash
mvnw spring-boot:run
```

브라우저에서 `http://localhost:7777` 접속

### 5. Eclipse에서 실행 (팀원용)

1. `File → Import → Existing Maven Projects`
2. Root Directory: 클론한 `plantcare` 폴더 선택
3. Finish
4. `PlantCareApplication.java` 우클릭 → `Run As → Spring Boot App`

## 기술 스택

| 분류 | 기술 |
|------|------|
| Backend | Spring Boot 3.5, Java 17 |
| ORM | MyBatis 3.0 |
| View | JSP + JSTL |
| DB | MySQL 5.7 |
| Build | Maven |
| API | 농촌진흥청 식물정보 API |

## 프로젝트 구조

```
src/main/java/kr/ac/tukorea/plantcare/
├── controller/    # 컨트롤러 (요청 라우팅)
├── service/       # 비즈니스 로직 + API 호출
├── repository/    # MyBatis Mapper
├── dto/           # 데이터 전송 객체
├── config/        # 설정 (Multipart 등)
└── PlantCareApplication.java

src/main/webapp/
└── views/
    ├── layout/    # header.jsp, footer.jsp
    ├── home.jsp           # 식물 목록 + 오늘 물 줄 식물
    ├── plantRegister.jsp  # 식물 검색 + 등록
    ├── plantDetail.jsp    # 식물 상세/수정/삭제
    └── calendar.jsp       # 월간 물주기 캘린더

src/main/resources/
├── static/css/style.css
├── mapper/         # MyBatis XML
└── application.properties
```
