# 식물집사 (Plant Parent Care)

> 개인 맞춤형 식물 물주기 일정관리 서비스 — Spring Boot + JSP + MyBatis

## 시작하기

### 1. 클론

```bash
git clone https://github.com/Doehyun77/Plantcare.git
```

### 2. MySQL DB 생성

MySQL이 설치되어 있어야 합니다. 그런 다음:

**방법 A — 명령 프롬프트**
```bash
mysql -u root -p < sql/init.sql
```
→ 비밀번호는 **본인의 MySQL root 비밀번호** 입력 (설치할 때 직접 설정한 것)

**방법 B — MySQL Workbench**
1. Workbench 실행 후 root 계정으로 접속
2. `sql/init.sql` 파일 열기 (`File → Open SQL Script`)
3. 번개 아이콘(Execute) 클릭

### 3. 프로젝트 실행

**방법 A — STS (Eclipse)**
1. `File → Import → Existing Maven Projects`
2. `Plantcare` 폴더 선택 → Finish
3. `PlantCareApplication.java` 우클릭 → `Run As → Spring Boot App`

**방법 B — 명령줄**
```bash
cd Plantcare
mvnw spring-boot:run
```

### 4. 접속

브라우저에서 `http://localhost:7777` 열면 끝!

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
