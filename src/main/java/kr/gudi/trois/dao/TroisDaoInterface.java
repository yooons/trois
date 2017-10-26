package kr.gudi.trois.dao;

import java.util.HashMap;
import java.util.List;

public interface TroisDaoInterface {
	public List<HashMap<String, Object>> selectMyqna(HashMap<String, Object> param);
	public HashMap<String, Object> totCntMyqna();
	public List<HashMap<String, Object>> selectMyroom(HashMap<String, Object> param);
	public HashMap<String, Object> totCntMyroom();
	public int deleteMyroom(HashMap<String, Object> param);
	public List<HashMap<String, Object>> selectAdmin(HashMap<String, Object> param);
	public HashMap<String, Object> totCntAdmin();
	public int deleteAdmin(HashMap<String, Object> param);
}
