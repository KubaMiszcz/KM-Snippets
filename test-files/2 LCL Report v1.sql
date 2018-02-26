USE [C_HARTWIG_SO_DEVEL]
-- z procedury [schSO].[PrGetLclcShippingOperationsBySC]

DECLARE @intLCLTypeDictId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 10001 AND IsActive = 1)
DECLARE @LanguageDictId INT = 440001
-- polski, przekazywane jako parametr z aplikacji
DECLARE @vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
DECLARE @vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'

SELECT
	--1	Numer operacji	
	tSOMD.[OperationNumber] as [OperationNumber]
--2	Typ operacji	
	, OperationTypeName.Name as [OperationType]

/* -----------------------------------------------------------------*/
--3	Zleceniodawca CRM	
	, tS.[CRMNumber] as [PrincipalCRMNumber]
--4	Zleceniodawca NAV	
	, tS.[NavisionNumber] as [PrincipalNavisionNumber]
--5	Zleceniodawca Nazwa	
	, tS.Name as [PrincipalName] 
--6	Zleceniodawca NIP	
	, tS.NIP as [PrincipalNIP] 
--7	P�atnik 	
	, tP.Name as [PayerName]
--8	Dysponent	
	, @vcharIDontKnowWhere AS [Owner]
--9	Handlowiec	
	, TraderName.Name as [Trader]
--10	MPK	
	, MPKName.Name as [MPK]
--11	Numer referencyjny  PLATNIKA	
	, tSOM.[PayerReferenceNumber] 
--12	Typ numeru referencyjnego PLATNIKA	
	, PayerReferenceNumberTypeName.Name as [PayerReferenceNumberType]
--13	Kwota ubezpieczenia	
	, tSOM.[InsuranceAmount] 
--14	Data gotowo�ci towaru u za�adowcy	
	, tSOM.[DateOfReadiness]
--15	ETD	
	, tSO.[ETDorATDDate] AS [ETD]
--16	ETA	
	, tSO.[ETAorATADate] AS [ETA]
--17	Miejsce za�adunku	
	, tSOM.[LoadingPlace]
--18	Port za�adunku	
	, LoadingPortName.Name as [LoadingPort]
--19	Za�adowca	Opcje
	, @vcharIDontKnowWhere AS [Loader]
--20	Port wy�adunku	
	, UnloadingPortName.Name as [UnloadingPort]
--21	Odbiorca	Opcje
	, @vcharIDontKnowWhere AS [Recipient]
--22	Miejsce dostawy	
	, tSOM.[DeliveryPlace]
--23	CFS Origin	
	, CFSOriginName.Name as [CFSOrigin]
--24	CFS Destination	
	, CFSDestinationName.Name as [CFSDestination]
--25	Sprzeda� PL (z�)	suma z pozycji kalkulacji - cz�� sprzeda�owa
	, tSCalculationsPositions.[SellAmountPLN]
--26	Koszty PL (z�)	suma z pozycji kalkulacji - cz�� kosztowa
	, tSCalculationsPositions.[PurchaseAmountPLN]	
--27	Mar�a PL (z�)	wynik z pozycji kalkulacji (sprzeda� PL - koszty PL)
	--,tSCalculationsPositions.[MarginPLN]
	, (tSCalculationsPositions.[SellAmountPLN]-tSCalculationsPositions.[PurchaseAmountPLN]) as [MarginPLN]
--28	Rentowno�� PL (z�)	rentowno�� kalkulacji (Mar�a PL/ Sprzeda� PL) - warto�� procentowa
	, tSCalculationsPositions.[MarginAsPercentage]
--29	Sprzeda� (faktury z�)	suma z przypi�tych do operacji faktur sprzeda�owych
	, tSCalculationsPositions.[SalesInvoicesAmountPLN]
--30	Koszty (faktury z�)	suma z przypi�tych do operacji faktur kosztowych
	, tSCalculationsPositions.[PurchaseInvoicesAmountPLN]
--31	Mar�a (faktury z�)	wynik z przypi�tych faktur (sprzeda� - koszty)
	--,tSCalculations.[TotalMarginPercent]
	, (tSCalculationsPositions.[SalesInvoicesAmountPLN]-tSCalculationsPositions.[PurchaseInvoicesAmountPLN]) as [MarginInvoicesPLN]
--32	Rentowno�� (faktury z�)	rentowno�� operacji (Mar�a / Sprzeda�) - warto�� procentowa
	, (((tSCalculationsPositions.[SalesInvoicesAmountPLN]-tSCalculationsPositions.[PurchaseInvoicesAmountPLN])/tSCalculationsPositions.[SalesInvoicesAmountPLN])*100.0) as [MarginInvoicesAsPercentage]
--33	Operator LCL	dla sierot
	, LCLOperatorName.Name as [LCLOperator]
--34	Typ kontenera	z matki dla c�rek; dla sierot z OS
	, ContainerTypeName.Name as [ContainerType]
--35	Numer kontenera	z matki dla c�rek; dla sierot z OS
	, tSContainer.[Number]
--36	Armator	z matki dla c�rek; dla sierot z OS
	, ShipownerName.Name as [Shipowner]
--37	Cargo EN	dla matek pole niewidoczne
	, tSContainer.[CargoEn]
--38	�adunek PL	dla matek pole niewidoczne
	, tSContainer.[CargoPl]
--39	Masa brutto �adunku	suma z c�rek dla matki, dla c�rek i sierot z OS
	, tSContainer.[GrossWeight]
--40	Obj�to�� �adunku	suma z c�rek dla matki, dla c�rek i sierot z OS
	, tSContainer.[VolumeOfCargo]
--41	HS Code	
	, tSContainer.[HsCode]
--42	Liczba opakowa�	
	, tSContainer.[NumberOfPackages] 
--43	J.M.
	, MeasureUnitName.Name as [MeasureUnit]	
--44	W/M	
	, (CAST(tSCargo.[GrossWeight] AS VARCHAR(10)) + GrossWeightUnitName.Name + '/' + CAST(tSCargo.[VolumeOfCargo] AS VARCHAR(10)) + VolumeOfCargoUnitName.Name) as [W/M]


--45	Numer operacji c�rka	dla matek

--46	Numer operacji matka	dla c�rek
	, tSOMDMother.[OperationNumber] AS [MotherOperationNumber]
--47	Fracht morski kwota (sprzeda�/ kalkulacja/ z�)	
--48	Buking (numer czynno�ci/ link)	
	, @vcharApplicationAdress + CAST(tSAMD.[ActionNumber] AS VARCHAR(10)) AS [BookingLink]
--49	Dyspozycja celna (numer czynno�ci/ link)
--50	Formowanie (numer czynno�ci/link)	
--51	Rozformowanie (numer czynno�ci/link)	
--52	Roz�adunek (numer czynno�ci/link)	
--53	Za�adunek (numer czynno�ci/link)	
--54	Zlecenie transportowe (numer czynno�ci/link)	
--55	Data wykonania us�ugi	Pole do dodania   / ustalenia (faktury)



FROM
	--all I need
	[schSO].[tShippingOperationMainData] as tSOMD
	JOIN [schSO].[tShippingOperations] tSO
	ON tSOMD.[ShippingOperationMainDataId] = tSO.[ShippingOperationMainDataId]

	--linking tables for many to many	
	LEFT JOIN [schSO].[tShippingOperationsCalculations] tSOC
	ON tSO.[ShippingOperationId] = tSOC.[ShippingOperationId]
	LEFT JOIN [schSO].[tShippingOperationsContainers] tSOContainer
	ON tSO.[ShippingOperationId] = tSOContainer.[ShippingOperationId]
	LEFT JOIN [schSOA].[tShippingOperationsActions] tSOA --zmienilbym nazwe na [tShippingOperationsActionsMainData] bo potem laczym z [ShippingActionMainDataId]
	ON tSO.[ShippingOperationId] = tSOA.[ShippingOperationId]
	--------------------------------------------------------------------------------------

	--1 straight from tSOMD
	--2
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] OperationType
	ON tSOMD.[OperationTypeId] = OperationType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] OperationTypeName
	ON OperationType.[DictionaryItemVersionId] = OperationTypeName.[DictionaryItemVersionId]
		AND OperationTypeName.LanguageDictId = @LanguageDictId
	--3 
	LEFT JOIN [schSO].[tShippingOperationMetrics] tSOM
	ON tSO.[ShippingOperationMetricId] = tSOM.[ShippingOperationMetricId]
	LEFT JOIN [schSubjects].[tSubjects] tS
	ON tSOM.[PrincipalSubjectId] = tS.[SubjectId]
	--4 straight from tS joined before
	--5 straight from tS joined before
	--6 straight from tS joined before
	--7 
	LEFT JOIN [schSubjects].[tSubjects] tP
	ON tSOM.[PayerSubjectId] = tP.[SubjectId]
	--9
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] Trader
	ON tSOM.[TraderId] = Trader.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] TraderName
	ON Trader.DictionaryItemVersionId = TraderName.[DictionaryItemVersionId]
		AND Tradername.LanguageDictId = @LanguageDictId
	--10 
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] MPK
	ON tSOM.[MpkId] = MPK.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] MPKName
	ON MPK.DictionaryItemVersionId = MPKName.[DictionaryItemVersionId]
		AND MPKName.LanguageDictId = @LanguageDictId
	--11 straight from tSOM joined before
	--12
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] PayerReferenceNumberType
	ON tSOM.[PayerReferenceNumberTypeId] = PayerReferenceNumberType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] PayerReferenceNumberTypeName
	ON PayerReferenceNumberType.DictionaryItemVersionId = PayerReferenceNumberTypeName.[DictionaryItemVersionId]
		AND PayerReferenceNumberTypeName.LanguageDictId = @LanguageDictId
	--13 straight from tSOM joined before
	--14 straight from tSOM joined before
	--17 straight from tSOM joined before
	--18
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] LoadingPort
	ON tSOM.[LoadingPortId] = LoadingPort.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] LoadingPortName
	ON LoadingPort.DictionaryItemVersionId = LoadingPortName.[DictionaryItemVersionId]
		AND LoadingPortName.LanguageDictId = @LanguageDictId
	--20
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] UnloadingPort
	ON tSOM.[UnloadingPortId] = UnloadingPort.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] UnloadingPortName
	ON UnloadingPort.DictionaryItemVersionId = UnloadingPortName.[DictionaryItemVersionId]
		AND UnloadingPortName.LanguageDictId = @LanguageDictId
	--22 straight from tSOM joined before
	--23
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] CFSOrigin
	ON tSOM.CFSOriginId = CFSOrigin.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] CFSOriginName
	ON CFSOrigin.DictionaryItemVersionId = CFSOriginName.[DictionaryItemVersionId]
		AND CFSOriginName.LanguageDictId = @LanguageDictId
	--24
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] CFSDestination
	ON tSOM.CFSDestinationId = CFSDestination.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] CFSDestinationName
	ON CFSDestination.DictionaryItemVersionId = CFSDestinationName.[DictionaryItemVersionId]
		AND CFSDestinationName.LanguageDictId = @LanguageDictId
	--25 
	LEFT JOIN [schSO].[tShippingCalculations] tSCalculations
	ON tSOC.[ShippingCalculationId] = tSCalculations.[ShippingCalculationId]
	LEFT JOIN [schSO].[tShippingCalculationPositions] tSCalculationsPositions
	ON tSCalculations.[ShippingCalculationId] = tSCalculationsPositions.[ShippingCalculationId]
	--26 straight from tSCalculationsPositions joined before
	--27 straight from tSCalculations joined before
	--28 straight from tSCalculations joined before
	--29 straight from tSCalculations joined before
	--30 straight from tSCalculations joined before
	--31 straight from tSCalculations joined before
	--33
	LEFT JOIN [schSO].[tShippingContainers] tSContainer
	ON tSOContainer.[ShippingContainerId] = tSContainer.[ShippingContainerId]
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] LCLOperator
	ON tSContainer.[LCLOperatorId] = LCLOperator.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] LCLOperatorName
	ON LCLOperator.DictionaryItemVersionId = LCLOperatorName.[DictionaryItemVersionId]
		AND LCLOperatorName.LanguageDictId = @LanguageDictId
	--34
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] ContainerType
	ON tSContainer.[CargoTypeId] = ContainerType.[DictionaryItemVersionId] --zmienilbym nazwe [CargoTypeId] na [ContainerTypeId] bo chyba o typ kontenra chodzi
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] ContainerTypeName
	ON ContainerType.DictionaryItemVersionId = ContainerTypeName.[DictionaryItemVersionId]
		AND ContainerTypeName.LanguageDictId = @LanguageDictId
	--35 straight from tSContainer joined before
	--36
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] Shipowner
	ON tSOM.CFSDestinationId = Shipowner.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] ShipownerName
	ON Shipowner.DictionaryItemVersionId = ShipownerName.[DictionaryItemVersionId]
		AND ShipownerName.LanguageDictId = @LanguageDictId
	--37 straight from tSContainer joined before
	--38 straight from tSContainer joined before
	--39 straight from tSContainer joined before
	--40 straight from tSContainer joined before
	--41 straight from tSContainer joined before
	--42 straight from tSContainer joined before
	--43
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] MeasureUnit
	ON tSContainer.[UnitOfMeasureId] = MeasureUnit.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] MeasureUnitName
	ON MeasureUnit.DictionaryItemVersionId = MeasureUnitName.[DictionaryItemVersionId]
		AND MeasureUnitName.LanguageDictId = @LanguageDictId
	--44
	LEFT JOIN [schSO].[tShippingCargos] tSCargo
	ON tSOContainer.[ShippingContainerId] = tSCargo.[ShippingContainerId]
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] GrossWeightUnit
	ON tSCargo.GrossWeightUnitDictId = GrossWeightUnit.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] GrossWeightUnitName
	ON GrossWeightUnit.DictionaryItemVersionId = GrossWeightUnitName.[DictionaryItemVersionId]
		AND GrossWeightUnitName.LanguageDictId = @LanguageDictId
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] VolumeOfCargoUnit
	ON tSCargo.[VolumeOfCargoUnitDictId] = VolumeOfCargoUnit.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] VolumeOfCargoUnitName
	ON VolumeOfCargoUnit.DictionaryItemVersionId = VolumeOfCargoUnitName.[DictionaryItemVersionId]
		AND VolumeOfCargoUnitName.LanguageDictId = @LanguageDictId
	--46	Numer operacji matka	dla c�rek
	LEFT JOIN [schSO].[tShippingOperations] tSOMother
	ON tSOMD.[ShippingOperationMainDataId] = tSOMother.[ParentOperationMainDataId]
	LEFT JOIN [schSO].[tShippingOperationMainData] tSOMDMother
	ON tSOMother.[ShippingOperationMainDataId] = tSOMDMother.[ShippingOperationMainDataId]
	--48	Buking (numer czynno�ci/ link)	
	LEFT JOIN [schSOA].[tShippingActionMainData] tSAMD
	ON tSOA.[ShippingActionMainDataId] = tSAMD.[ShippingActionMainDataId]



WHERE tSOMD.OperationTypeId = @intLCLTypeDictId AND tSO.IsActive = 1



