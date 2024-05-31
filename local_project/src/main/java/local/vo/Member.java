package local.vo;

public class Member extends Reply {
	private int memberId;			// 회원 ID (기본키)
	private String localId;			// 지역 ID
	private char codeId;  			// 권한코드 ID
	private String email;			// 이메일
	private String password;        // 비밀번호
	private String nicknm;			// 닉네임
	private String phone;			// 연락처
	private String status;			// 회원상태
	private String stopReason;		// 정지사유
	private String stopStartDate;	// 정지 시작 일시
	private String stopEndDate;		// 정지 종료 일시
	private String createdAt;		// 등록 일시
	private int createdBy;			// 등록한 회원 ID
	private String createdIp;		// 등록한 사람 IP
	private String modifiedAt;		// 수정 일시
	private int modifiedBy;			// 수정한 회원 ID
	private String modifiedIp;		// 수정한 사람 IP
	private String profilephoto;	// 프로필 사진
	private String addrExtra;      // 참고항목(OO동)
	private int reportCount;		// 신고된 횟수
	private String businessNumber; // 사업자등록번호

	
	
	
	public String getBusinessNumber() {
		return businessNumber;
	}
	public void setBusinessNumber(String businessNumber) {
		this.businessNumber = businessNumber;
	}
	public int getReportCount() {
		return reportCount;
	}
	public void setReportCount(int reportCount) {
		this.reportCount = reportCount;
	}
	public String getAddrExtra() {
		return addrExtra;
	}
	public void setAddrExtra(String addrExtra) {
		this.addrExtra = addrExtra;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}
	public String getLocalId() {
		return localId;
	}
	public void setLocalId(String localId) {
		this.localId = localId;
	}
	public char getCodeId() {
		return codeId;
	}
	public void setCodeId(char codeId) {
		this.codeId = codeId;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStopReason() {
		return stopReason;
	}
	public void setStopReason(String stopReason) {
		this.stopReason = stopReason;
	}
	public String getStopStartDate() {
		return stopStartDate;
	}
	public void setStopStartDate(String stopStartDate) {
		this.stopStartDate = stopStartDate;
	}
	public String getStopEndDate() {
		return stopEndDate;
	}
	public void setStopEndDate(String stopEndDate) {
		this.stopEndDate = stopEndDate;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedIp() {
		return createdIp;
	}
	public void setCreatedIp(String createdIp) {
		this.createdIp = createdIp;
	}
	public String getModifiedAt() {
		return modifiedAt;
	}
	public void setModifiedAt(String modifiedAt) {
		this.modifiedAt = modifiedAt;
	}
	public int getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedIp() {
		return modifiedIp;
	}
	public void setModifiedIp(String modifiedIp) {
		this.modifiedIp = modifiedIp;
	}
	public String getProfilephoto() {
		return profilephoto;
	}
	public void setProfilephoto(String profilephoto) {
		this.profilephoto = profilephoto;
	}
	
	
	
	
	
	
	
	
	
	
	
}
