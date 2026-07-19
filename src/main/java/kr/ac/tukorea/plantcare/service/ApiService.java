package kr.ac.tukorea.plantcare.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.dataformat.xml.XmlMapper;

import kr.ac.tukorea.plantcare.dto.PlantInfoDTO;

@Service
public class ApiService {

	private final RestTemplate restTemplate;
	private final XmlMapper xmlMapper;

	@Value("${api.nongsaro.key}")
	private String apiKey;

	private static final String BASE_URL = "http://api.nongsaro.go.kr/service/garden";

	public ApiService() {
		this.restTemplate = new RestTemplate();
		this.xmlMapper = new XmlMapper();
	}

	/**
	 * 식물명으로 검색 (자동완성)
	 */
	public List<PlantInfoDTO> searchPlants(String keyword) {
		try {
			String url = UriComponentsBuilder.fromHttpUrl(BASE_URL + "/gardenList")
				.queryParam("apiKey", apiKey)
				.queryParam("sType", "sCntntsSj")
				.queryParam("sText", keyword)
				.queryParam("pageNo", "1")
				.queryParam("numOfRows", "20")
				.build()
				.toString();

			String xml = restTemplate.getForObject(url, String.class);
			return parseGardenListXml(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	/**
	 * API 상세 조회
	 */
	public PlantInfoDTO getPlantDetail(String cntntsNo) {
		try {
			String url = UriComponentsBuilder.fromHttpUrl(BASE_URL + "/gardenDtl")
				.queryParam("apiKey", apiKey)
				.queryParam("cntntsNo", cntntsNo)
				.build()
				.toString();

			String xml = restTemplate.getForObject(url, String.class);
			return parseGardenDtlXml(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * gardenList XML 파싱
	 */
	private List<PlantInfoDTO> parseGardenListXml(String xml) throws Exception {
		List<PlantInfoDTO> list = new ArrayList<>();
		XmlMapper mapper = new XmlMapper();

		var root = mapper.readTree(xml);
		var itemsNode = root.path("body").path("items").path("item");

		if (itemsNode.isMissingNode() || itemsNode.isNull()) {
			return list;
		}

		if (itemsNode.isObject()) {
			PlantInfoDTO dto = mapItemToDto(itemsNode);
			if (dto != null) list.add(dto);
		} else if (itemsNode.isArray()) {
			for (var item : itemsNode) {
				PlantInfoDTO dto = mapItemToDto(item);
				if (dto != null) list.add(dto);
			}
		}
		return list;
	}

	/**
	 * gardenDtl XML 파싱
	 */
	private PlantInfoDTO parseGardenDtlXml(String xml) throws Exception {
		XmlMapper mapper = new XmlMapper();
		var root = mapper.readTree(xml);
		var bodyNode = root.path("body").path("item");

		if (bodyNode.isMissingNode()) return null;
		return mapDetailToDto(bodyNode);
	}

	private PlantInfoDTO mapItemToDto(com.fasterxml.jackson.databind.JsonNode item) {
		PlantInfoDTO dto = new PlantInfoDTO();
		dto.setCntntsNo(getText(item, "cntntsNo"));
		dto.setPlantName(getText(item, "cntntsSj"));
		// rtnFileUrl: 전체 URL이 pipe로 여러 개 (|), 첫 번째 사용
		String fileUrl = getText(item, "rtnFileUrl");
		if (fileUrl != null && !fileUrl.isEmpty()) {
			dto.setImageUrl(fileUrl.split("\\|")[0].trim());
		}
		return dto;
	}

	private PlantInfoDTO mapDetailToDto(com.fasterxml.jackson.databind.JsonNode item) {
		PlantInfoDTO dto = new PlantInfoDTO();
		dto.setCntntsNo(getText(item, "cntntsNo"));
		dto.setPlantName(getText(item, "cntntsSj"));
		dto.setPlantSciName(getText(item, "plntbneNm"));
		dto.setPlantEngName(getText(item, "plntzrNm"));
		dto.setDistbNm(getText(item, "distbNm"));
		// gardenDtl에 이미지 필드가 없어 imageUrl 설정 안 함 (search에서 캐시된 값 사용)
		dto.setWaterSpring(getText(item, "watercycleSprngCode"));
		dto.setWaterSpringDesc(getText(item, "watercycleSprngCodeNm"));
		dto.setWaterSummer(getText(item, "watercycleSummerCode"));
		dto.setWaterSummerDesc(getText(item, "watercycleSummerCodeNm"));
		dto.setWaterAutumn(getText(item, "watercycleAutumnCode"));
		dto.setWaterAutumnDesc(getText(item, "watercycleAutumnCodeNm"));
		dto.setWaterWinter(getText(item, "watercycleWinterCode"));
		dto.setWaterWinterDesc(getText(item, "watercycleWinterCodeNm"));
		dto.setManageLevel(getText(item, "manageLevelCode"));
		dto.setGrowthInfo(getText(item, "growthInfo"));
		dto.setFncltyInfo(getText(item, "fncltyInfo"));
		dto.setOrgplceInfo(getText(item, "orgplceInfo"));
		dto.setSpeclmanageInfo(getText(item, "speclmanageInfo"));
		dto.setToxctyInfo(getText(item, "toxctyInfo"));
		return dto;
	}

	private String getText(com.fasterxml.jackson.databind.JsonNode node, String field) {
		var v = node.path(field);
		return (v.isMissingNode() || v.isNull()) ? null : v.asText();
	}

}
